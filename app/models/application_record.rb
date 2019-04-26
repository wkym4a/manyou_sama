class ApplicationRecord < ActiveRecord::Base
  include MakeSql
# include SqlMakr

  self.abstract_class = true

end
