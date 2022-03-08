class Admin::UnlinksController < AdminController
  def create
    redirection = Redirection.find(params[:redirection_id])

    if redirection.unlink
      flash[:success] = "Unlinked #{redirection.slug}"
      redirect_to admin_redirections_path
    else
      flash[:error] = "Something went wrong"
      redirect_to admin_redirections_path
    end
  end
end
