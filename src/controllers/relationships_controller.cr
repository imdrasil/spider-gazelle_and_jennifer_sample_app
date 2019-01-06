class RelationshipsController < Application
  base "relationships"

  before_action :ensure_login

  def create
    user = User.find!(params["follow[followed_id]"])
    current_user!.follow(user)
    redirect_to user_path(user.id)
  end

  def destroy
    user = User.find!(params["id"])
    current_user!.unfollow(user)
    redirect_to user_path(user.id)
  end
end
