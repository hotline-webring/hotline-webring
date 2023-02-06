class Api::UnlinksController < ApiController
  def create
    redirection = Redirection.find_by!(slug: params[:redirection_slug])

    if redirection.unlink
      render json: { success: true }, status: 201
    else
      render json: { success: false }, status: 500
    end
  end
end
