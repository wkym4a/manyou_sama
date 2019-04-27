class ApplicationRecord < ActiveRecord::Base
  include MakeSql
# include SqlMakr
  include ApplicationHelper
  include SessionsHelper

  self.abstract_class = true

end
