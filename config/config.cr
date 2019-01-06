require "./initializers/**"

# Application dependencies
require "action-controller"
require "form_object"
require "flash_container"
require "http_method_emulator"

# Application code
require "../src/models/application_record"
require "../src/models/**"

require "../src/mailers/application_mailer.cr"
require "../src/mailers/**"

require "../src/form_objects/**"

require "../src/views/application_view"
require "../src/views/**"

require "../src/controllers/application"
require "../src/controllers/*"

# Server required after application controllers
require "action-controller/server"

# Add handlers that should run before your application
ActionController::Server.before(
  HTTP::LogHandler.new(STDOUT),
  HTTP::ErrorHandler.new(ENV["SG_ENV"]? != "production"),
  HTTP::CompressHandler.new,
  HTTPMethodEmulator::Handler::INSTANCE
)

# Optional support for serving of static assests
static_file_path = ENV["PUBLIC_WWW_PATH"]? || "./public"
if File.directory?(static_file_path)
  # Check for files if no paths matched in your application
  ActionController::Server.before(
    ActionController::FileHandler.new(static_file_path, directory_listing: false)
  )
end

# Configure session cookies
# NOTE:: Change these from defaults
ActionController::Session.configure do
  settings.key = ENV["COOKIE_SESSION_KEY"]? || "_spider_gazelle_"
  settings.secret = ENV["COOKIE_SESSION_SECRET"]? || "4f74c0b358d5bab4000dd3c75465dc2c"
  # settings.encrypted = false
end

APP_NAME = "Spider-Gazelle"
VERSION  = "1.0.0"
