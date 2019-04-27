class User < ApplicationRecord
  has_secure_password

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :cd, presence: true, length: {maximum:3} , uniqueness:true
  validates :name, presence: true, length: {maximum:20}
  validates :email, presence: true, length: {maximum:250} , uniqueness:true,
             format:{with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  # before_destroy :cannot_delete_myself
  # attr_accessor :current_user_id

  #パスワードのバリデーションチェックは「have_pass」時のみ
  #……【通常の（パスワード以外を変更する）プロフィール更新ではチェックしない
  validates :password ,presence: true , length: {minimum: 2 , maximum: 40} , on: :have_pass
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  has_many :tasks ,dependent: :destroy
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

  def get_users_index()

    sql = " select users.id"
    sql += " ,users.cd"
    sql += " ,users.name"
    sql += " ,count(tasks.id) as task_count"

    sql += " from users"
    sql += " left join tasks"
    sql += " on tasks.user_id = users.id"
    sql += " group by "
    sql += "  users.id"
    sql += " ,users.cd"
    sql += " ,users.name"

    sql += " order by users.cd"

    Task.find_by_sql(sql)

  end

  private

  # def cannot_delete_myself
  #   if id == current_user_id
  #     errors.add(:cd, I18n.t("activerecord.errors.messages.restrict_dependent_destroy.myself"))
  #     throw :abort
  #   end
  #
  # end

end
