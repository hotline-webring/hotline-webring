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
    Redirection.find_by(slug: params[:slug]) ||
      RedirectionCreation.perform(referrer, params[:slug]) ||
      Redirection.first
  end

  def referrer
    request.env["HTTP_REFERER"]
  end
end
