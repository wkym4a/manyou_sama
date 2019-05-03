class Tag < ApplicationRecord

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :cd, presence: true, length: {maximum:3} , uniqueness:true
  validates :name, presence: true, length: {maximum:20}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  has_many :task_tags, dependent: :restrict_with_error
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end
