class SessionController < Application
  base "/"

  get "/sign_in", :new do
    render html: page(Session::NewView)
  end

  post "/sign_in", :create do
    # l = Logger.new(STDOUT)
    # l.level = Logger::DEBUG

    # l.debug(params.inspect)

    user = User.where { _email == params["session[email]"] }.first
    # l.debug(user.inspect)

    if user && user.authenticate(params["session[password]"].to_s)
      if user.activated?
        log_in user
        flash[:info] = t("create.info")
        redirect_to root_path
      else
        flash[:warning] = t("create.warning")
        redirect_to root_path
      end
    else
      flash[:danger] = t("create.danger")
      render html: page(Session::NewView)
    end
  end

  delete "/sign_out", :destroy do
    session.delete("user_id")
    flash[:info] = t("destroy.info")
    redirect_to root_path
  end
end
