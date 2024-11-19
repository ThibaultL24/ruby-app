# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
end
