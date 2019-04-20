class ApplicationController < ActionController::Base
  include MakeSql
  
  protect_from_forgery with: :exception
      #
      # include MakeSql
  # include SqlMakr
end
