class RedirectionsController < ApplicationController
  before_action :ensure_referrer_is_not_localhost
  before_action :ensure_referrer_is_not_blocked

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
    Redirection.find_by(slug: params[:slug]) ||
      create_redirection ||
      log_headers_and_use_fallback_redirection

  end

  def create_redirection
    if ENV.fetch("DISALLOW_CREATING_NEW_REDIRECTIONS", false)
      false
    else
      RedirectionCreation.perform(referrer, params[:slug])
    end
  end

  def log_headers_and_use_fallback_redirection
    tagged_log "Redirection creation failed."
    if request.env["HTTP_UPGRADE_INSECURE_REQUESTS"].present?
      tagged_log "It likely failed because the links use HTTP instead of HTTPS"
    end
    if referrer.blank?
      tagged_log "Referrer is BLANK!"
    else
      tagged_log "Referrer: #{referrer}"
    end
    tagged_log "Here are all of the HTTP headers:"
    tagged_log http_headers
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
    if HostValidator.new(referrer).invalid?
      redirect_to page_path("localhost")
    end
  end

  def ensure_referrer_is_not_blocked
    if Redirection.exists?(slug: params[:slug])
      # If the redirection already exists, let it through. We just want to
      # prevent further redirections from being created.
      return
    end

    if Block.new(referrer).blocked?
      redirect_to Redirection.first.url, allow_other_host: true
    end
  end
end
