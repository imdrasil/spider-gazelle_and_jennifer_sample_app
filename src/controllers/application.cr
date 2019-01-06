require "./concerns/*"

abstract class Application < ActionController::Base
  include ViewModel
  include RouterHelper
  include SessionHelper

  property current_user : User?
  @current_user_loaded = false

  before_action :set_date_header
  after_action :store_flash

  @page_title : String? = nil
  @__flash__ : FlashContainer?

  macro page(klass, *args)
    {{klass}}.new({{args.splat}}{% if args.size > 0 %},{% end %} flash, current_user, @page_title).render
  end

  def flash
    @__flash__ ||= FlashContainer.from_session(session[FlashContainer.key]?.as(String?))
  end

  def current_user
    return @current_user if @current_user_loaded
    @current_user = if user_id = session["user_id"]?
      User.find(user_id)
    end
  end

  private def redirect_back
    redirect_to request.headers["Referer"]? || root_path
  end

  private def log_in(user : User)
    session["user_id"] = user.id.not_nil!.to_s
  end

  private def ensure_login
    return if signed_in?
    flash["info"] = t("ensure_login")
    redirect_to sign_in_path
  end

  private def page
    (params["page"]? || 0).to_i
  end

  private def t(key, *args, **opts)
    I18n.translate("#{self.class.to_s.underscore}.#{key}", *args, **opts)
  end

  private def set_date_header
    response.headers["Date"] = HTTP.format_time(Time.now)
  end

  private def store_flash
    session[FlashContainer.key] = flash.to_session
  end
end

class ActionController::Session
  def encode(cookies)
    # If there was no existing session and
    return if !@existing && self.empty?

    # TODO:: Add secure setting

    data, age =
      if @existing && self.empty?
        {"", 0}
      else
        data = @encoder.prepare(self.to_json)
        raise CookieSizeExceeded.new("#{data.size} > #{MAX_COOKIE_SIZE}") if data.size > MAX_COOKIE_SIZE
        {data, settings.max_age}
      end
    cookies[settings.key] = HTTP::Cookie.new(
      settings.key,
      data,
      settings.path,
      Time.now + age.seconds,
      http_only: true,
      extension: "SameSite=Strict"
    )
  end
end
