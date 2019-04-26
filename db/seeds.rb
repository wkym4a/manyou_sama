# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

first_user = User.new
first_user.cd = "000"
first_user.name = "管理用初期ユーザー"
first_user.email = "kanri@test.co.jp"
first_user.password = "password"
first_user.password_confirmation = "password"

first_user.save

tasks_first_user = Task.where(" user_id is null ")
tasks_first_user.update(user_id: first_user.id)
