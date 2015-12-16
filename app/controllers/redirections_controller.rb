class RedirectionsController < ApplicationController
  before_action :ensure_referrer_is_not_localhost

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
    Redirection.find_by(slug: params[:slug]) ||
      RedirectionCreation.perform(referrer, params[:slug]) ||
      Redirection.first
  end

  def referrer
    request.env["HTTP_REFERER"]
  end

  def ensure_referrer_is_not_localhost
    if referrer.present? && URI.parse(referrer).host == "localhost"
      redirect_to page_path("localhost")
    end
  end
end
