class RedirectionsController < ApplicationController
  before_action :ensure_referrer_is_not_localhost
  before_action :ensure_referrer_is_not_blocked
  before_action :ensure_request_is_not_from_a_bot
  before_action :ensure_request_is_not_a_subdomain_of_an_existing_site
  before_action :ensure_slug_matches_original_domain

  def next
    redirection = find_or_create_redirection

    redirect_to redirection.next_url, allow_other_host: true
  end

  def previous
    redirection = find_or_create_redirection

    redirect_to redirection.previous_url, allow_other_host: true
  end

  private

  def find_or_create_redirection
    if existing_redirection
      existing_redirection.tap do |redirection|
        redirection.touch(:last_seen_at)
      end
    else
      # Always log headers when possibly creating a new Redirection.
      # This ensures that if something goes wonky, we can look back through the
      # logs.
      log_headers
      create_redirection || use_fallback_redirection
    end
  end

  def create_redirection
    if Rails.configuration.disallow_creating_new_redirections
      false
    else
      RedirectionCreation.perform(
        referrer,
        params[:slug],
        open: !Rails.configuration.closed
      )
    end
  end

  def log_headers
    if referrer.blank?
      tagged_log "Referrer is BLANK! (Maybe they set `Referrer-Policy: no-referrer`?)"
    else
      tagged_log "Referrer: #{referrer}"
    end
    tagged_log "Here are all of the HTTP headers:"
    tagged_log http_headers
  end

  def use_fallback_redirection
    tagged_log "Redirection creation failed."
    if request.env["HTTP_UPGRADE_INSECURE_REQUESTS"].present?
      tagged_log "It likely failed because the links use HTTP instead of HTTPS"
    end
    Redirection.first
  end

  def referrer
    request.env["HTTP_REFERER"]
  end

  def http_headers
    http_only = ->(key, _) { key.start_with?("HTTP") }
    cookie_header = ->(key, _) { key == "HTTP_COOKIE" }
    request.env.select(&http_only).reject(&cookie_header)
  end

  def tagged_log(message)
    logger.info "[#{params[:slug]}] #{message}"
  end

  def ensure_referrer_is_not_localhost
    if creating_new_redirection?
      if HostValidator.new(referrer).invalid?
        redirect_to page_path("localhost")
      end
    end
  end

  def ensure_referrer_is_not_blocked
    if creating_new_redirection?
      if Block.new(referrer).blocked?
        redirect_to Redirection.first.url, allow_other_host: true
      end
    end
  end

  def ensure_request_is_not_from_a_bot
    if creating_new_redirection?
      user_agent = request.env["HTTP_USER_AGENT"]
      if DeviceDetector.new(user_agent).bot?
        log_with_headers "Detected a bot with user agent: #{user_agent}"
        redirect_to Redirection.first.url, allow_other_host: true
      end
    end
  end

  def ensure_request_is_not_a_subdomain_of_an_existing_site
    if creating_new_redirection?
      referrer_without_leading_subdomain = URI.parse(referrer).host.
        sub(/^[^.]+\./, "")
      match = Redirection.all.find { |r| URI.parse(r.url).host == referrer_without_leading_subdomain }
      if match
        log_with_headers "Trying to add a redirection for #{referrer_without_leading_subdomain} which conflicts with existing #{match.url}"
        redirect_to Redirection.first.url, allow_other_host: true
      end
    end
  end

  def ensure_slug_matches_original_domain
    if referrer && existing_redirection.present?
      referrer_host = normalized_host(referrer)
      if referrer_host != normalized_host(existing_redirection.url)
        log_with_headers "Slug's URL (#{existing_redirection.url}) does not match incoming referrer (normalized to #{referrer_host})"
        redirect_to existing_slug_path(params[:slug])
      end
    end
  end

  def log_with_headers(message)
    tagged_log message
    log_headers
  end

  def normalized_host(url)
    URI.parse(url).normalize.host.sub(/^www\./, "")
  end

  def creating_new_redirection?
    referrer && existing_redirection.nil?
  end

  def existing_redirection
    @_existing_redirection = params[:slug] &&
      Redirection.find_by(slug: params[:slug])
  end
end
