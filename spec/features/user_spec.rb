require 'rails_helper'
require 'date'

RSpec.feature "Users", type: :feature do
  context "step19,20の試験" do

    #試験の前提条件
    # => 「user1」および「user1」が登録されている。
    # => 「user1」の仕事「task_user1」および「user2」の仕事「task_user2」が登録されている。
    # => 他にユーザー，仕事はなく、テスト開始段階ではログインも行われていない。
    let!(:user1) { FactoryBot.create(:user,cd: "001",name: "T_name01",email: "test01@test.co.jp",password: "pass01") }
    let!(:task_user1) { FactoryBot.create(:task,user_id: user1.id,name: "TN_user1",content: "TC_user1") }

    let!(:user2) { FactoryBot.create(:user,cd: "002",name: "T_name02",email: "test02@test.co.jp",password: "pass02") }
    let!(:task_user2) { FactoryBot.create(:task,user_id: user2.id,name: "TN_user2",content: "TC_user2") }

    ####↓↓↓↓テストシナリオ↓↓↓↓####
    #実施するテスト
    #【1:既存ユーザーでログイン】から……user1でログインして、
    scenario "1-1:新規ユーザー登録画面に遷移（urlで……ボタンはそもそもない）→できない。" do
      sign_in_as user1
      visit new_user_path

      expect(page).not_to have_content I18n.t('screen.new',name: I18n.t('activerecord.models.task'))
    end

    scenario "1-2:自身のユーザープレビュー画面に遷移（ボタンで）→自分の名前が表示される。" do
      sign_in_as user1
      visit new_user_path#←とりあえずどこでもいいので訪れる（ヘッダボタンを押すため
      click_link  I18n.t("head_info.show_logined_user_info")

      expect(page).to have_content user1.name
    end


    scenario "1-3:自身のユーザーレビュー画面に遷移（urlで）→自分の名前が表示される。" do
      sign_in_as user1
      visit user_path(user1.id)

      expect(page).to have_content user1.name
    end

    scenario "1-4:他人（user2)のユーザーレビュー画面に遷移（urlで……ボタンはそもそもない）→自分の名前も相手の名前も表示されない。" do
      sign_in_as user1
      visit user_path(user2.id)

      expect(page).not_to have_content user1.name
      expect(page).not_to have_content user2.name
    end

    scenario "1-5:一覧画面を表示", js: true do
      sign_in_as user1
      visit new_user_path#←とりあえずどこでもいいので訪れる（ヘッダボタンを押すため
      click_link  I18n.t("screen.index", name: I18n.t("activerecord.models.task"))

      # =>・user1のしごとは表示される。
      expect(page).to have_content task_user1.name
      # =>・user2のしごとは表示されない。
      expect(page).not_to have_content task_user2.name
      # =>・「進捗変更ボタン」は表示される。
      expect(page).to have_button I18n.t('activerecord.attributes.task.status_btn') +  I18n.t('action.change')

      # =>・「更新ボタン」は表示される。
      expect(page).to have_content I18n.t('condition.edit')

      #↓↓↓
      #user2のcdで再検索
      fill_in :input_user_cd  ,with: user2.cd
      find("#tasks_limit_asc").click
      # =>・user1のしごとは表示されない。
      expect(page).not_to have_content task_user1.name
      # =>・user2のしごとは表示される。
      expect(page).to have_content task_user2.name
      # =>・「進捗変更ボタン」は表示ない。
      expect(page).not_to have_button I18n.t('activerecord.attributes.task.status_btn') +  I18n.t('action.change')
      # =>・「更新ボタン」は表示ない。
      expect(page).not_to have_content I18n.t('condition.edit')
    end

    scenario "1-5-2:一覧画面を表示(urlで)", js: true do
      sign_in_as user1
      visit tasks_path

      # =>・user1のしごとは表示される。
      expect(page).to have_content task_user1.name
      # =>・user2のしごとは表示されない。
      expect(page).not_to have_content task_user2.name
      # =>・「進捗変更ボタン」は表示される。
      expect(page).to have_button I18n.t('activerecord.attributes.task.status_btn') +  I18n.t('action.change')

      # =>・「更新ボタン」は表示される。
      expect(page).to have_content I18n.t('condition.edit')

      #↓↓↓
      #user2のcdで再検索
      fill_in :input_user_cd  ,with: user2.cd
      find("#tasks_limit_asc").click
      # =>・user1のしごとは表示されない。
      expect(page).not_to have_content task_user1.name
      # =>・user2のしごとは表示される。
      expect(page).to have_content task_user2.name
      # =>・「進捗変更ボタン」は表示ない。
      expect(page).not_to have_button I18n.t('activerecord.attributes.task.status_btn') +  I18n.t('action.change')
      # =>・「更新ボタン」は表示ない。
      expect(page).not_to have_content I18n.t('condition.edit')
    end

    scenario "【2:ログインせずに一覧画面へ（urlで……ボタンはそもそもない）】→できない。" do
      visit tasks_path

      expect(page).not_to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
    end

    scenario "【3:新規ユーザーを作成→ログイン】から", js: true  do

      #→新規ユーザー登録（user3(仮)）
      visit new_user_path
      fill_in :user_cd  ,with: "003"
      fill_in :user_name  ,with: "T_name03"
      fill_in :user_email  ,with: "test03@test.co.jp"
      fill_in :user_password  ,with: "pass03"
      fill_in :user_password_confirmation  ,with: "pass03"
      click_button I18n.t('action.new')

      #→プレビュー画面に遷移し、名称が表示される
      expect(page).to have_content  "003"
      expect(page).to have_content  "T_name03"

      #→一覧画面へ
      click_link  I18n.t("screen.index", name: I18n.t("activerecord.models.task"))

      #→検索結果……user1,2のtask、ともになし
      expect(page).not_to have_content task_user1.name
      expect(page).not_to have_content task_user2.name

      #↓↓↓
      #→検索条件なしに変更して再検索
      fill_in :input_user_cd  ,with: ""
      find("#tasks_limit_asc").click

      #→検索結果……user1,2のtask、ともにあり
      expect(page).to have_content task_user1.name
      expect(page).to have_content task_user2.name
      #→「進捗変更ボタン」「更新ボタン」の表示はともになし
      expect(page).not_to have_button I18n.t('activerecord.attributes.task.status_btn') +  I18n.t('action.change')
      expect(page).not_to have_content I18n.t('condition.edit')

    end

    scenario "【3-2:新規ユーザーを作成→ログイン】", js: true  do
    #……【3】と同じ内容を、『user1でログイン→ログアウト』してから行う
      sign_in_as user1
      click_link I18n.t("head_info.do_logout")

      #→新規ユーザー登録（user3(仮)）
      visit new_user_path
      fill_in :user_cd  ,with: "003"
      fill_in :user_name  ,with: "T_name03"
      fill_in :user_email  ,with: "test03@test.co.jp"
      fill_in :user_password  ,with: "pass03"
      fill_in :user_password_confirmation  ,with: "pass03"
      click_button I18n.t('action.new')

      #→プレビュー画面に遷移し、名称が表示される
      expect(page).to have_content  "003"
      expect(page).to have_content  "T_name03"

      #→一覧画面へ
      click_link  I18n.t("screen.index", name: I18n.t("activerecord.models.task"))

      #→検索結果……user1,2のtask、ともになし
      expect(page).not_to have_content task_user1.name
      expect(page).not_to have_content task_user2.name

      #↓↓↓
      #→検索条件なしに変更して再検索
      fill_in :input_user_cd  ,with: ""
      find("#tasks_limit_asc").click

      #→検索結果……user1,2のtask、ともにあり
      expect(page).to have_content task_user1.name
      expect(page).to have_content task_user2.name
      #→「進捗変更ボタン」「更新ボタン」の表示はともになし
      expect(page).not_to have_button I18n.t('activerecord.attributes.task.status_btn') +  I18n.t('action.change')
      expect(page).not_to have_content I18n.t('condition.edit')

    end

    scenario "【4:違うパスワードでログイン→失敗】", js: true  do

      visit new_session_path
      fill_in "cd", with: "aaa"
      fill_in "password", with: user1.password
      click_button "Log in"

      expect(page).to have_content I18n.t('session.wrong_user_cd')
      expect(page).to have_content I18n.t("head_info.is_not_logined")

      fill_in "cd", with: user1.cd
      fill_in "password", with: user2.password
      click_button "Log in"

      expect(page).to have_content I18n.t('session.wrong_password')
      expect(page).to have_content I18n.t("head_info.is_not_logined")
    end

  end

  context "step21、ユーザー管理画面の試験" do

    #試験の前提条件
    # => 「user1」および「user1」が登録されている。
    # => 「user1」の仕事「task_user1」および「user2」の仕事「task_user2」が登録されている。
    # => 他にユーザー，仕事はなく、テスト開始段階ではログインも行われていない。
    let!(:user1) { FactoryBot.create(:user,cd: "001",name: "T_name01",email: "test01@test.co.jp",password: "pass01") }
    let!(:task_user1) { FactoryBot.create(:task,user_id: user1.id,name: "TN_user1",content: "TC_user1") }

    let!(:user2) { FactoryBot.create(:user,cd: "002",name: "T_name02",email: "test02@test.co.jp",password: "pass02") }
    let!(:task_user2) { FactoryBot.create(:task,user_id: user2.id,name: "TN_user2",content: "TC_user2") }

    ####↓↓↓↓テストシナリオ↓↓↓↓####
    #実施するテスト
    #ログインしていないなら、管理画面に（uelでも）遷移できない

    #ログインしていれば一覧画面を表示でき
    #そこですべてのユーザーが表示されていて
    #他のユーザーは削除できるが
    #自分自身は削除できない

    #新規登録すると
    #その情報がインデックス画面に表示される

    #更新すると
    #その情報がインデックス画面に表示される

    #初期、タスク数0件
    #タスクを登録すると、その件数がインデックス画面に反映される

    #【1:既存ユーザーでログイン】から……user1でログインして、

    scenario "【1:ログインしていないなら、管理画面に（urlでも）遷移できない】"  do
      visit admin_users_path

      expect(page).not_to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.user'))+ "(" + I18n.t('authority.for_admin') + ")"
    end

    scenario "【2:ログインして一覧画面表示→削除】"  do
      #ログインしていれば一覧画面を表示でき
      sign_in_as user1
      visit admin_users_path
      expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.user'))+ "(" + I18n.t('authority.for_admin') + ")"
      #そこですべてのユーザーが表示されていて
      expect(page).to have_content user1.name
      expect(page).to have_content user2.name

      #他のユーザーは削除できるが
      within '.index_line_1' do
        click_link I18n.t('action.delete')
      end
      expect(page).to have_content user1.name
      expect(page).not_to have_content user2.name

      #自分自身は削除できない
      within '.index_line_0' do
        click_link I18n.t('action.delete')
      end
      expect(page).to have_content user1.name
      expect(page).not_to have_content user2.name

    end

    scenario "【3:新規登録するとその情報がインデックス画面に表示される】"  do

      sign_in_as user1
      visit admin_users_path
      click_link 'New User'

      fill_in :user_cd  ,with: "003"
      fill_in :user_name  ,with: "T_name03"
      fill_in :user_email  ,with: "test03@test.co.jp"
      fill_in :user_password  ,with: "pass03"
      fill_in :user_password_confirmation  ,with: "pass03"
      click_button I18n.t('action.new')

      #→一覧画面に遷移し、コード、名称が表示される
      expect(page).to have_content  "003"
      expect(page).to have_content  "T_name03"

    end

    scenario "【4:更新登録するとその情報がインデックス画面に表示される】"  do

      sign_in_as user1
      visit admin_users_path

      within '.index_line_0' do
        click_link I18n.t('action.edit')
      end

      fill_in :user_name  ,with: "change_name"
      click_button I18n.t('action.edit')

      #→一覧画面に遷移
      visit admin_users_path
      expect(page).to have_content  "change_name"
      expect(page).not_to have_content  user1.name
      expect(page).to have_content user2.name

    end

    scenario "【5:仕事を登録すると、その件数が一覧表示に反映される】"  do

      sign_in_as user1
      visit admin_users_path
      expect(page).to have_content "1"+ I18n.t('unit_name.items')
      expect(page).not_to have_content "2"+ I18n.t('unit_name.items')


      FactoryBot.create(:task,user_id: user1.id,name: "TN_user1_2",content: "TC_user1_2")
      visit admin_users_path
      expect(page).to have_content "1"+ I18n.t('unit_name.items') #user2が持つ仕事は「1件」のまま
      expect(page).to have_content "2"+ I18n.t('unit_name.items')

    end
  end

end
