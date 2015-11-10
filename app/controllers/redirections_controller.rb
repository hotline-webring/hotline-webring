class RedirectionsController < ApplicationController
  def next
    redirection = Redirection.find_by(slug: params[:slug])

    redirect_to redirection.next_url
  end

  def previous
    redirection = Redirection.find_by(slug: params[:slug])

    redirect_to redirection.previous_url
  end
end
