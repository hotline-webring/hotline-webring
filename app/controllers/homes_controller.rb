class HomesController < ApplicationController
  def show
    @redirections ||= Redirection.in_ring_order
  end
end
