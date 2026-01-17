class Admin::BaseController < ApplicationController
  include Authorization

  before_action :require_admin

  layout "application"
end
