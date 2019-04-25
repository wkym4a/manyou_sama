class User < ApplicationRecord
  has_secure_password

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :cd, presence: true, length: {maximum:3} , uniqueness:true
  validates :name, presence: true, length: {maximum:20}
  validates :email, presence: true, length: {maximum:250} , uniqueness:true,
             format:{with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  #パスワードのバリデーションチェックは「have_pass」時のみ
  #……【通常の（パスワード以外を変更する）プロフィール更新ではチェックしない
  validates :password ,presence: true , length: {minimum: 2 , maximum: 40} , on: :have_pass
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  has_many :tasks ,dependent: :destroy
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end
