class RegistrationController < Application
  base "/"

  get "/sign_up", :new do
    user = NewUserForm.new(User.new)
    render html: page(Users::NewView, user)
  end

  post "/sign_up", :create do
    user = NewUserForm.new(User.new)
    if user.verify(request) && user.save
      flash["success"] = t("create.success")
      redirect_to root_path
    else
      flash["danger"] = t("create.danger")
      render html: page(Users::NewView, user)
    end
  end
end
