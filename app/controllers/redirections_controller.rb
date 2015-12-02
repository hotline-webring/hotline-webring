class RedirectionsController < ApplicationController
  def next
    redirection = find_or_create_redirection

    redirect_to redirection.next_url
  end

  def previous
    redirection = find_or_create_redirection

    redirect_to redirection.previous_url
  end

  private

  def find_or_create_redirection
    redirection = Redirection.find_by(slug: params[:slug])

    redirection.presence || new_redirection
  end

  def new_redirection
    redirection = Redirection.new(slug: params[:slug])

    if referrer.present?
      redirection.url = referrer_hostname
      Ring.new(redirection).link
      redirection
    else
      Redirection.first
    end
  end

  def referrer_hostname
    referrer_uri = URI.parse(referrer)
    "#{referrer_uri.scheme}://#{referrer_uri.hostname}"
  end

  def referrer
    request.env["HTTP_REFERER"]
  end
end
