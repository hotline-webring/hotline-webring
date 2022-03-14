class Admin::RedirectionsController < AdminController
  def index
    @redirections = Redirection.order(created_at: :desc)
  end

  def edit
    @redirection = Redirection.find_by(id: params[:id])
  end

  def update
    @redirection = Redirection.find_by(id: params[:id])

    if @redirection.update(redirection_params)
      flash[:success] = "Updated #{@redirection.slug}"
      redirect_to admin_redirections_path
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  private

  def redirection_params
    params.require(:redirection).permit(:url)
  end
end
