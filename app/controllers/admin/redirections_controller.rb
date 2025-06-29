class Admin::RedirectionsController < AdminController
  DEFAULT_SORT_PARAMS = {"sort_key" => "next_id", "sort_dir" => "desc"}

  def index
    sort_by = DEFAULT_SORT_PARAMS.merge(sort_params)
    @redirections = Redirection.order_nulls_last(sort_by)
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

  def sort_params
    params.permit(:sort_key, :sort_dir)
  end
end
