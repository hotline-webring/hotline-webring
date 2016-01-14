class FeedsController < ApplicationController
  def show
    @redirections = Redirection.latest_first
    @last_redirection = Redirection.most_recent
  end
end
