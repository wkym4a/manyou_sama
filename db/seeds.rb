# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


######↓初回実施用#####
if User.all.size==0
# ユーザーデータがまだない場合のみ、「ユーザー作成処理」を実行するよう変更

  first_user = User.new
  first_user.cd = "000"
  first_user.name = "管理用初期ユーザー"
  first_user.email = "kanri@test.co.jp"
  first_user.password = "password"
  first_user.password_confirmation = "password"

  first_user.save

  tasks_first_user = Task.where(" user_id is null ")
  tasks_first_user.update(user_id: first_user.id)
end
######↑初回実施用#####

#↓管理者権限追加に伴い、いったん全員を管理者にするseed
User.update_all(admin_status: 9)

if Tag.find_by(cd: "000").nil?
  tag0 = Tag.new
  tag0.cd = "000"
  tag0.name = "会長案件"
  tag0.save
end

if Tag.find_by(cd: "001").nil?
  tag1 = Tag.new
  tag1.cd = "001"
  tag1.name = "社長案件"
  tag1.save
end

if Tag.find_by(cd: "002").nil?
  tag2 = Tag.new
  tag2.cd = "002"
  tag2.name = "役員案件"
  tag2.save
end

if Tag.find_by(cd: "003").nil?
  tag3 = Tag.new
  tag3.cd = "003"
  tag3.name = "部長案件"
  tag3.save
end

if Tag.find_by(cd: "004").nil?
  tag4 = Tag.new
  tag4.cd = "004"
  tag4.name = "課長案件"
  tag4.save
end

if Tag.find_by(cd: "101").nil?
  tag101 = Tag.new
  tag101.cd = "101"
  tag101.name = "要、社長決済"
  tag101.save
end

if Tag.find_by(cd: "102").nil?
  tag102 = Tag.new
  tag102.cd = "102"
  tag102.name = "要、役員決済"
  tag102.save
end

if Tag.find_by(cd: "103").nil?
  tag103 = Tag.new
  tag103.cd = "103"
  tag103.name = "要、部長決済"
  tag103.save
end

if Tag.find_by(cd: "104").nil?
  tag104 = Tag.new
  tag104.cd = "104"
  tag104.name = "要、課長決済"
  tag104.save
end
