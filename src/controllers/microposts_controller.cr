class MicropostsController < Application
  base "microposts"

  @micropost : Micropost?

  before_action :ensure_login
  before_action :ensure_user, only: %i(destroy)

  def create
    micropost = Micropost.build({user_id: current_user!.id})
    form = NewMicropostForm.new(micropost)
    if form.verify(request) && form.save
      flash[:success] = t("create.success")
      redirect_to root_path
    else
      feed_items = current_user!.microposts_query.paginate(page)
      render html: page(Home::IndexView, feed_items)
    end
  end

  def destroy
    if micropost!.destroy
      flash[:success] = t("destroy.success")
    else
      flash[:alert] = t("destroy.alert")
    end
    redirect_back
  end

  private def micropost
    @micropost ||= Micropost.find(params["id"])
  end

  private def micropost!
    micropost.not_nil!
  end

  private def ensure_user
    redirect_to root_path unless micropost
  end
end
