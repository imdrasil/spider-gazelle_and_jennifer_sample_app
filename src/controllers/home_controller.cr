class HomeController < Application
  base "/"

  def index
    render html: page(Home::IndexView, feed_items)
  end

  get "/about", :about do
    render html: page(Home::AboutView)
  end

  private def feed_items
    if signed_in?
      current_user!.feed_query.paginate(page)
    else
      Pager::JenniferCollection(Micropost).empty
    end
  end
end
