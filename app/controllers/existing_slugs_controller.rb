class ExistingSlugsController < ApplicationController
  def show
    @slug = params[:id]
    @next_url = Redirection.find_by(slug: @slug).next_url
  end
end
