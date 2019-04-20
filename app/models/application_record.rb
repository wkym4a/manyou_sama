class ApplicationRecord < ActiveRecord::Base
  include MakeSql
# include SqlMakr

  self.abstract_class = true




  def tttttest2(s)
    return "aiueokaki2"
  end

end
