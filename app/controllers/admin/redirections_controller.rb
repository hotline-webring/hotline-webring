class Admin::RedirectionsController < AdminController
  def index
    @redirections = Redirection.order(created_at: :desc)
  end
end
