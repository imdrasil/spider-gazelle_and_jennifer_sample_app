class UsersController < Application
  base "users"

  before_action :ensure_login
  before_action :ensure_role, only: %i(destroy)

  def index
    users = User.all.where { _activated }.paginate(page)
    render html: page(Users::IndexView, users)
  end

  def show
    user = User.find!(params["id"])
    unless user.activated?
      redirect_to root_path
      return
    end
    microposts = user.microposts_query.paginate(page)
    render html: page(Users::ShowView, user, microposts)
  end

  def edit
    puts params.inspect
    user = User.find!(params["id"])
    unless current_user?(user)
      redirect_to root_path
      return
    end
    form = UpdateUserForm.new(user)
    render html: page(Users::EditView, user, form)
  end

  def update
    user = User.find!(params["id"])
    unless current_user?(user)
      redirect_to root_path
      return
    end
    form = UpdateUserForm.new(user)
    if form.verify(request) && form.save
      flash[:success] = t("update.success")
      redirect_to root_path
    else
      render html: page(Users::EditView, user, form)
    end
  end

  def destroy
    User.find!(params["id"]).destroy
    flash[:success] = t("destroy.success")
    redirect_to users_path
  end

  get "/:id/following", :following do
    @page_title = t("following.title")
    this_user = User.find!(params["id"])
    users = this_user.following_query.paginate(page)
    render html: page(Users::FollowView, this_user, users)
  end

  get "/:id/followers", :followers do
    @page_title = title = t("followers.title")
    this_user = User.find!(params["id"])
    users = this_user.followers_query.paginate(page)
    render html: page(Users::FollowView, this_user, users)
  end

  private def ensure_role
    redirect_to root_path unless current_user!.admin?
  end
end
