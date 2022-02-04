class Admin::BlocksController < AdminController
  def create
    redirection = Redirection.find(params[:redirection_id])
    blocked_referrer = BlockedReferrer.new_from_url(redirection.url)

    if blocked_referrer.save && redirection.unlink
      flash[:success] = "Blocked and unlinked #{blocked_referrer.host_with_path}"
      redirect_to admin_redirections_path
    else
      flash[:error] = "Something went wrong"
      redirect_to admin_redirections_path
    end
  end
end
