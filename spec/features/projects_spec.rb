require 'rails_helper'
require 'date'


RSpec.feature "Projects", type: :feature do
# RSpec.feature "Projects", type: :feature , js: true do
  context "step18まで" do
#……同一ユーザーでログインしていることを前庭とする（異なるユーザーを考慮したテストは）。


  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task,user_id: user.id) }

    # before(:each) do
    #   ActiveRecord::Base.record_timestamps = true
    #
    #   #ユーザー情報作成
    #   user = FactoryBot.create(:user)
    #   #ユーザーでログイン
    #   sign_in_as user
    #   #タスク情報登録
    #   task = FactoryBot.create(:task,user_id: user.id)
    # end


    #############↓タスク機能についてのテスト↓#################1
    ########----↓↓タスク一覧画面テスト↓↓----###########2
    ####--↓↓↓画面遷移テスト↓↓↓3
    scenario "タスク機能関係、画面遷移動作確認……「一覧」→「新規」" do
      sign_in_as user
      visit tasks_path
      click_link I18n.t('condition.new') + I18n.t('activerecord.models.task')
      # click_button "新規タスク"←bootstrapでボタン化したものは、rspecではボタンとして認識されないっぽい！
      expect(page).to have_content I18n.t('screen.new' ,name:  I18n.t('activerecord.models.task'))
    end

    scenario "タスク機能関係、画面遷移動作確認……「一覧」→「更新」(一覧画面、条件無しで検索してから)", js: true do
      sign_in_as user
      #↑
      #[js: true do]→jsの動作に対応するため追記……『RspecによるRailsテスト入門』、104〜106頁あたり参照

      #タスク情報登録
      task2 = FactoryBot.create(:task,content: "タスク登録データ確認、内容詳細",user_id: user.id)
      task3 = FactoryBot.create(:task,content: "ダミー",user_id: user.id)

      visit tasks_path
      #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
      #(step14にて、クリックするボタンを変更)
      find_by_id('tasks_created_at_desc').click
      find("#tasks_created_at_desc").click
      #click_button I18n.t('action.search')

      click_link "goto_task" + task2.id.to_s + "_edit"

      expect(page).to have_content I18n.t('screen.edit' ,name:  I18n.t('activerecord.models.task'))
      expect(page).to have_content task2.content

    end

    scenario "タスク機能関係、画面遷移動作確認……「一覧」→「閲覧」(一覧画面、条件無しで検索してから)", js: true do
      sign_in_as user

      #タスク情報登録
      task2 = FactoryBot.create(:task,content: "abcdefg",user_id: user.id)
      task3 = FactoryBot.create(:task,content: "dummy",user_id: user.id)

      visit tasks_path
      #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
      #(step14にて、クリックするボタンを変更)
      find("#tasks_created_at_desc").click
      #click_button I18n.t('action.search')

      click_link "goto_task" + task2.id.to_s + "_show"

      expect(page).to have_content I18n.t('screen.show' ,name:  I18n.t('activerecord.models.task'))
      expect(page).to have_content task2.content
    end
    ####--↑↑↑画面遷移テスト↑↑↑3

    ####--↓↓↓画面表示テスト↓↓↓3
    scenario "「タスク一覧」画面動作確認、登録したデータが一覧に表示されている(一覧画面、条件無しで検索してから)", js: true do
      sign_in_as user

      #タスク情報登録
      task2 = FactoryBot.create(:task,content: "content_content_content",user_id: user.id)

      visit tasks_path
      #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
      #(step14にて、クリックするボタンを変更)
      find("#tasks_created_at_desc").click
      #click_button I18n.t('action.search')

      #登録したデータ（の、仕事名）が表示されている
      expect(page).to have_content task2.content
    end

    scenario "登録したデータが作成日時順に表示されている（step11対応のための追加改修）(一覧画面、条件無しで検索してから)", js: true do
      sign_in_as user

      #テスト用に、タイムスタンプの自動設定をoffに
      ActiveRecord::Base.record_timestamps = false

      #タスク情報登録
      #「作成日時が明日であるデータ」を先に登録
      task_tomorrow = FactoryBot.create(:task,content: "create_tomorrow",
        created_at: Time.now.tomorrow ,updated_at: Time.now.tomorrow,user_id: user.id)
      #「作成日時が現在であるデータ」を後に2回登録
      task_now_1 = FactoryBot.create(:task,content: "create_now_1",
        created_at: Time.now ,updated_at: Time.now,user_id: user.id)
      task_now_2 = FactoryBot.create(:task,content: "create_now_2",
        created_at: Time.now ,updated_at: Time.now,user_id: user.id)

      #他のテストに影響を与えないよう、タイムスタンプの自動設定をonに戻す
      ActiveRecord::Base.record_timestamps = true

      visit tasks_path
      #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
      #(step14にて、クリックするボタンを変更)
      find("#tasks_created_at_desc").click
      #click_button I18n.t('action.search')

      #一行目（line_0）→初めに登録した「task_tomorrow」……∵、作成日時は「明日」
      #二行目（line_1）→最後に登録した「task_now_2」……∵、作成日時は「【task_now_1】よりも後」
      #三行目（line_2）→二番目に登録した「task_now_1」
      expect(page).to have_selector '.index_line_0', text:  task_tomorrow.content
      expect(page).to have_selector '.index_line_1', text:  task_now_2.content
      expect(page).to have_selector '.index_line_2', text:  task_now_1.content

    end

    ####--↑↑↑画面表示テスト↑↑↑3
    ########----↑↑タスク一覧画面テスト↑↑----###########2

    ########----↓↓新規タスク登録画面テスト↓↓----###########2
    ####--↓↓↓画面遷移テスト↓↓↓3
    scenario "タスク機能関係、画面遷移動作確認……「新規」→戻る→「一覧」" do
      sign_in_as user
      visit new_task_path
      click_link I18n.t('condition.back')
      expect(page).to have_content  I18n.t('screen.index' ,name:  I18n.t('activerecord.models.task'))
    end
    ####--↑↑↑画面遷移テスト↑↑↑3

    ####--↓↓↓登録テスト↓↓↓3
    scenario "何も入力しないで登録するとエラー" do
      sign_in_as user
      visit new_task_path
      click_button I18n.t('helpers.submit.create')

      expect(page).to have_content I18n.t('screen.new',name: I18n.t('activerecord.models.task'))
      expect(page).to have_content I18n.t('errors.template.header.none')
    end

    scenario "タスク名だけ入力して登録すると登録成功" do
      sign_in_as user
      visit new_task_path
      fill_in "name" ,with: "abababab"

      expect{
        click_button I18n.t('helpers.submit.create')

        #新規登録後、更新画面で再表示」が不評だったので、「一覧画面に遷移」に変えてみる
        expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
        # expect(page).to have_content I18n.t('screen.edit',name: I18n.t('activerecord.models.task'))

        expect(page).to have_content I18n.t('activerecord.normal_process.do_save')
            }.to change(Task.all, :count).by(1)
    end
    ####--↑↑↑登録テスト↑↑↑3
    ########----↑↑新規タスク登録画面テスト↑↑----###########2

    ########----↓↓タスク更新画面テスト↓↓----###########2
    ####--↓↓↓画面遷移テスト↓↓↓3
    scenario "タスク機能関係、画面遷移動作確認……「更新」→戻る→「一覧」" do
      sign_in_as user

      task = FactoryBot.create(:task,user_id: user.id)
      visit edit_task_path(task.id)
      click_link I18n.t('condition.back')
      expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
    end
    ####--↑↑↑画面遷移テスト↑↑↑3

    ####--↓↓↓登録テスト↓↓↓3
    #更新時、名前変更不可とするつもり（デザイン調整時に実装）なので名前ではなく詳細変更で試験
    scenario "詳細を入力して更新(一覧画面、条件無しで検索してから)", js: true do
      sign_in_as user
      task = FactoryBot.create(:task,user_id: user.id)
      visit edit_task_path(task.id)
      fill_in "content" ,with: "change_taskcontent_change"

      expect{
        click_button I18n.t('helpers.submit.create')
        expect(page).to have_content I18n.t('activerecord.normal_process.do_update')
        click_link I18n.t('condition.back')
        #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
        #(step14にて、クリックするボタンを変更)
        find("#tasks_created_at_desc").click
        #click_button I18n.t('action.search')

        expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
        expect(page).to have_content "change_taskcontent_change"
            }.to change(Task.all, :count).by(0)
    end

    scenario "データ削除(一覧画面、条件無しで検索してから)", js: true do
      sign_in_as user
      task = FactoryBot.create(:task ,name: "this_will_del",user_id: user.id)
      visit edit_task_path(task.id)

      expect{
        click_link I18n.t('helpers.submit.delete')
        #  click_button "OK"
        #……↑【「確認画面表示」→「キャンセル」「OK」で「OK」だと削除】は省略される模様
        #↓js有効時には↑は省略されないようなので、「OK」ボタンも押してやる必要がある
        page.driver.browser.switch_to.alert.accept
        #click_button 'OK'
        #click_link 'OK'

        expect(page).to have_content I18n.t('activerecord.normal_process.do_del',this: I18n.t('activerecord.models.task'))
        expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
        expect(page).not_to have_content "this_will_del"
            }.to change(Task.all, :count).by(-1)
    end
    ####--↑↑↑登録テスト↑↑↑3

    ########----↓↓タスク閲覧画面テスト↓↓----###########2
    ####--↓↓↓画面遷移テスト↓↓↓3
    scenario "タスク機能関係、画面遷移動作確認……「閲覧」→戻る→「一覧」" do
      sign_in_as user

      task = FactoryBot.create(:task,user_id: user.id)
      visit task_path(task.id)
      click_link I18n.t('condition.back')
      expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
    end
    ####--↑↑↑画面遷移テスト↑↑↑3
    ########----↑↑タスク閲覧画面テスト↑↑----###########2
    #############↑タスク機能についてのテスト↑#################1

    #############画面の基本的な動作についてのテストはここまで。#################1
    #############これ以降はステップごとの【追加した機能についてのシナリオテスト】を作成していく。#################1
    scenario "ステップ14、「終了期限」追加に伴うシナリオテスト" , js: true do
      sign_in_as user
      #テストシナリオ
      # テストデータ1:【新規画面、「終了期限＝本日日付」で登録】
      # テストデータ2:【新規画面、「終了期限＝本日日付」で登録】
      #               => （新規登録後、検索画面に遷移するので）【「終了期限＝10日後」で更新】
      # テストデータ3:【新規画面、「終了期限＝本日日付」で登録】
      #               => （新規登録後、検索画面に遷移するので）【「終了期限＝未設定」で更新】
      # テストデータ4:【新規画面、「終了期限＝未設定」で登録】
      # ↓以降、検索画面での検索結果検証
      # テスト1:検索画面を表示し、「期限＝未設定」で検索
      #         データ1:無い。データ2:無い。データ3:ある。データ4:ある。
      # テスト2:検索画面を表示し、「検索画面に遷移し、「期限＝本日〜10日後」で検索し、
      #         データ1:ある。データ2:ある。データ3:無い。データ4:無い。
      # =>     （他にbeforeで登録した「期限＝1.week.from_now」のデータが存在
      # テスト3:「テスト2」の状態から「期限、昇順(↓)」でソート
      #         一行目がデータ1（期限＝本日）
      # テスト4:「テスト3」の状態から「期限、降順(↑)」でソート
      #         一行目がデータ2（期限＝10日後）

      #※非常に稀なテストエラー想定……テストが走っている最中に日付が変わると、エラーが発生する可能性があります。
      #  12時直前での試験は避けましょう。

      # テストデータ1:【新規画面、「終了期限＝本日日付」で登録】
      visit new_task_path
      fill_in "name" , with: "data1"
      fill_in "content" , with: "test_step14_data1"
      fill_in "limit" ,  with: Date.today.strftime("%Y/%m/%d")
      click_button I18n.t('helpers.submit.create')

      # テストデータ2:【新規画面、「終了期限＝本日日付」で登録】
      #               => （新規登録後、検索画面に遷移するので）【「終了期限＝10日後」で更新】
      visit new_task_path
      fill_in "name" , with: "data2"
      fill_in "content" , with: "test_step14_data2"
      fill_in "limit" ,  with: Date.today.strftime("%Y/%m/%d")
      click_button I18n.t('helpers.submit.create')

      #新規登録後、更新画面で再表示」が不評だったので、「一覧画面に遷移」に変えてみる
      #→登録データが一行目に表示されるので、その「更新」ボタンを押して更新画面に移動
      within '.index_line_0' do
        click_link I18n.t('action.edit')
      end

      fill_in "limit" ,  with: (Date.today + 10).strftime("%Y/%m/%d")
      click_button I18n.t('helpers.submit.create')

      # テストデータ3:【新規画面、「終了期限＝本日日付」で登録】
      #               => （新規登録後、検索画面に遷移するので）【「終了期限＝未設定」で更新】
      visit new_task_path
      fill_in "name" , with: "data3"
      fill_in "content" , with: "test_step14_data3"
      fill_in "limit" ,  with: Date.today.strftime("%Y/%m/%d")
      click_button I18n.t('helpers.submit.create')

      #新規登録後、更新画面で再表示」が不評だったので、「一覧画面に遷移」に変えてみる
      #→登録データが一行目に表示されるので、その「更新」ボタンを押して更新画面に移動
      within '.index_line_0' do
        click_link I18n.t('action.edit')
      end

      fill_in "limit" , with: ""
      click_button I18n.t('helpers.submit.create')

      # テストデータ4:【新規画面、「終了期限＝未設定」で登録】
      visit new_task_path
      fill_in "name" , with: "data4"
      fill_in "content" , with: "test_step14_data4"
      fill_in "limit" , with: ""
      click_button I18n.t('helpers.submit.create')

      # テスト1:検索画面を表示し、「期限＝未設定」で検索
      #         データ1:無い。データ2:無い。データ3:ある。データ4:ある。
      visit tasks_path

      check "no_limit"
      find("#tasks_created_at_desc").click
      expect(page).not_to have_content "test_step14_data1"
      expect(page).not_to have_content "test_step14_data2"
      expect(page).to have_content "test_step14_data3"
      expect(page).to have_content "test_step14_data4"

      checkbox = find("#no_limit")
      expect(checkbox).to be_checked

      # テスト2:検索画面を表示し、「検索画面に遷移し、「期限＝本日〜10日後」で検索し、
      visit tasks_path
      fill_in "limit_from" ,  with: Date.today.strftime("%Y/%m/%d")
      fill_in "limit_to" ,  with: (Date.today + 10).strftime("%Y/%m/%d")
      find("#tasks_created_at_desc").click

      #         データ1:ある。データ2:ある。データ3:無い。データ4:無い。
      # =>     （他にbeforeで登録した「期限＝1.week.from_now」のデータが存在
      expect(page).to have_content "test_step14_data1"
      expect(page).to have_content "test_step14_data2"
      expect(page).not_to have_content "test_step14_data3"
      expect(page).not_to have_content "test_step14_data4"

      # テスト3:「テスト2」の状態から「期限、昇順(↓)」でソート
      find("#tasks_limit_asc").click
      #         一行目がデータ1（期限＝本日）
      expect(page).to have_selector '.index_line_0', text: "test_step14_data1"

      # テスト4:「テスト3」の状態から「期限、降順(↑)」でソート
      find("#tasks_limit_desc").click
      #         一行目がデータ2（期限＝10日後）
      expect(page).to have_selector '.index_line_0', text: "test_step14_data2"

    end

    scenario "ステップ15、「作業状態」追加に伴うシナリオテスト" , js: true do
      sign_in_as user
      #テストシナリオ
      # 事前登録データ……終了期限＝一週間後
      # テストデータ1:【FactoryBot、「終了期限＝本日日付＋1日」でデータ作成】
      # テストデータ2:【FactoryBot、「終了期限＝本日日付＋2日」でデータ作成】※名称に「partial_match」を含める
      # テストデータ3:【FactoryBot、「終了期限＝本日日付＋3日」でデータ作成】
      # テストデータ4:【FactoryBot、「終了期限＝本日日付＋4日」でデータ作成】※名称に「partial_match」を含める
      # テストデータ5:【FactoryBot、「終了期限＝本日日付＋5日」でデータ作成】
      # テストデータ6:【FactoryBot、「終了期限＝本日日付＋6日」でデータ作成】※名称に「partial_match」を含める
      # ↓検索画面を表示
      # 「終了期限、降順」で検索
      # => 0〜5行目に、テストデータ1〜6が順に並ぶ
      # ↓
      # テストデータ1,2(0,1行目)→進捗状態「完了」に変更
      # テストデータ3,4(2,3行目)→進捗状態「作業中」に変更
      #
      # ####テスト準備完了 memo(save_and_open_page)
      #
      # テスト1:検索画面を表示し、「進捗状態＝完了」で検索
      #         データ1:ある。データ2:ある。データ3:無い。データ4:無い。データ5:無い。データ6:無い。
      # テスト2:検索画面を表示し、「進捗状態＝作業中」で検索
      #         データ1:無い。データ2:無い。データ3:ある。データ4:ある。データ5:無い。データ6:無い。
      # テスト3:検索画面を表示し、「進捗状態＝未着手」で検索
      #         データ1:無い。データ2:無い。データ3:無い。データ4:無い。データ5:ある。データ6:ある。
      # テスト4:検索画面を表示し、「進捗状態＝未着手＋作業中」「名称＝partial_match」で検索
      #         データ1:無い。データ2:無い。データ3:無い。データ4:ある。データ5:無い。データ6:ある。

      #※非常に稀なテストエラー想定……テストが走っている最中に日付が変わると、エラーが発生する可能性があります。
      #  12時直前での試験は避けましょう。


      # テストデータ1:【FactoryBot、「終了期限＝本日日付＋1日」でデータ作成】
      task1 = FactoryBot.create(:task,name: "abcdefg",content: "test_step15_data1",limit: 1.day.from_now,user_id: user.id)
      # テストデータ2:【FactoryBot、「終了期限＝本日日付＋2日」でデータ作成】※名称に「partial_match」を含める
      task2 = FactoryBot.create(:task,name: "partial_match",content: "test_step15_data2",limit: 2.day.from_now,user_id: user.id)
      # テストデータ3:【FactoryBot、「終了期限＝本日日付＋3日」でデータ作成】
      task3 = FactoryBot.create(:task,name: "abcdefg",content: "test_step15_data3",limit: 3.day.from_now,user_id: user.id)
      # テストデータ4:【FactoryBot、「終了期限＝本日日付＋4日」でデータ作成】※名称に「partial_match」を含める
      task4 = FactoryBot.create(:task,name: "b_cpartial_matchde",content: "test_step15_data4",limit: 4.day.from_now,user_id: user.id)
      # テストデータ5:【FactoryBot、「終了期限＝本日日付＋5日」でデータ作成】
      task5 = FactoryBot.create(:task,name: "abcdefg",content: "test_step15_data5",limit: 5.day.from_now,user_id: user.id)
      # テストデータ6:【FactoryBot、「終了期限＝本日日付＋6日」でデータ作成】※名称に「partial_match」を含める
      task6 = FactoryBot.create(:task,name: "yypartial_match___",content: "test_step15_data6",limit: 6.day.from_now,user_id: user.id)
      # ↓検索画面を表示
      # 「終了期限、降順」で検索
      # => 0〜5行目に、テストデータ1〜6が順に並ぶ
      visit tasks_path
      find("#tasks_limit_asc").click

      # テストデータ1,2(0,1行目)→進捗状態「完了」に変更
      within '.index_line_0' do
        choose Task.get_status_name(9)
        find("#btn_status_change_" + task1.id.to_s ).click
      end
      within '.index_line_1' do
        choose Task.get_status_name(9)
        find("#btn_status_change_" + task2.id.to_s ).click
      end
      # テストデータ3,4(2,3行目)→進捗状態「作業中」に変更
      within '.index_line_2' do
        choose Task.get_status_name(1)
        find("#btn_status_change_" + task3.id.to_s ).click
      end
      within '.index_line_3' do
        choose Task.get_status_name(1)
        find("#btn_status_change_" + task4.id.to_s ).click
      end

      # ####テスト準備完了 memo(save_and_open_page)
      #
      # テスト1:検索画面を表示し、「進捗状態＝完了」で検索
      #         データ1:ある。データ2:ある。データ3:無い。データ4:無い。データ5:無い。データ6:無い。
      visit tasks_path
      check "status_9"
      find("#tasks_created_at_desc").click
      expect(page).to have_content "test_step15_data1"
      expect(page).to have_content "test_step15_data2"
      expect(page).not_to have_content "test_step15_data3"
      expect(page).not_to have_content "test_step15_data4"
      expect(page).not_to have_content "test_step15_data5"
      expect(page).not_to have_content "test_step15_data6"

      # テスト2:検索画面を表示し、「進捗状態＝作業中」で検索
      #         データ1:無い。データ2:無い。データ3:ある。データ4:ある。データ5:無い。データ6:無い。
      visit tasks_path
      check "status_1"
      find("#tasks_created_at_desc").click
      expect(page).not_to have_content "test_step15_data1"
      expect(page).not_to have_content "test_step15_data2"
      expect(page).to have_content "test_step15_data3"
      expect(page).to have_content "test_step15_data4"
      expect(page).not_to have_content "test_step15_data5"
      expect(page).not_to have_content "test_step15_data6"

      # テスト3:検索画面を表示し、「進捗状態＝未着手」で検索
      #         データ1:無い。データ2:無い。データ3:無い。データ4:無い。データ5:ある。データ6:ある。
      visit tasks_path
      check "status_0"
      find("#tasks_created_at_desc").click
      expect(page).not_to have_content "test_step15_data1"
      expect(page).not_to have_content "test_step15_data2"
      expect(page).not_to have_content "test_step15_data3"
      expect(page).not_to have_content "test_step15_data4"
      expect(page).to have_content "test_step15_data5"
      expect(page).to have_content "test_step15_data6"

      # テスト4:検索画面を表示し、「進捗状態＝未着手＋作業中」「名称＝partial_match」で検索
      #         データ1:無い。データ2:無い。データ3:無い。データ4:ある。データ5:無い。データ6:ある。
      visit tasks_path
      check "status_0"
      check "status_1"
      fill_in "name" ,  with: "partial_match"
      find("#tasks_created_at_desc").click
      expect(page).not_to have_content "test_step15_data1"
      expect(page).not_to have_content "test_step15_data2"
      expect(page).not_to have_content "test_step15_data3"
      expect(page).to have_content "test_step15_data4"
      expect(page).not_to have_content "test_step15_data5"
      expect(page).to have_content "test_step15_data6"

    end


    scenario "ステップ16、「優先度」の登録およびそれを使ったソート" , js: true do
      sign_in_as user
      #テストシナリオ
      # テストデータ1:【新規画面、「優先度＝S」で登録】
      # テストデータ2:【新規画面、「優先度＝B(初期値、設定なし)」で登録】
      # テストデータ3:【新規画面、「優先度＝B(初期値、設定なし)」で登録】
      #               => （新規登録後、検索画面に遷移するので）【「優先度＝A」で更新】
      # テストデータ4:【新規画面、「優先度＝C」で登録】
      # ↓以降、検索画面での検索結果検証
      # テスト1:検索画面を表示し、「優先度＝S,A」で検索(新規登録と更新、両方で優先度を設定できることを確認)
      #         データ1:ある。データ2:無い。データ3:ある。データ4:無い。
      # テスト2:検索画面を表示し、「優先度＝S,A,B」で検索
      #         => 「優先度」でソート（desc:降順(低い順)……C,B,A,S）
      #         一行目がデータ2、二行目がデータ3、三行目がデータ1
      #         => 「優先度」でソート（asc:昇順(高い順)……S,A,B,C）
      #         一行目がデータ1、二行目がデータ3、三行目がデータ2

      # テストデータ1:【新規画面、「優先度＝S」で登録】
      visit new_task_path
      fill_in "name" , with: "data1"
      fill_in "content" , with: "test_step16_data1"
      choose Task.get_priority_name(0,1)
      click_button I18n.t('helpers.submit.create')

      # テストデータ2:【新規画面、「優先度＝B(初期値、設定なし)」で登録】
      visit new_task_path
      fill_in "name" , with: "data2"
      fill_in "content" , with: "test_step16_data2"
      click_button I18n.t('helpers.submit.create')

      # テストデータ3:【新規画面、「優先度＝B(初期値、設定なし)」で登録】
      #               => （新規登録後、検索画面に遷移するので）【「優先度＝A」で更新】】
      visit new_task_path
      fill_in "name" , with: "data3"
      fill_in "content" , with: "test_step16_data3"
      click_button I18n.t('helpers.submit.create')

      #新規登録後、更新画面で再表示」が不評だったので、「一覧画面に遷移」に変えてみる
      #→登録データが一行目に表示されるので、その「更新」ボタンを押して更新画面に移動
      within '.index_line_0' do
        click_link I18n.t('action.edit')
      end

      choose Task.get_priority_name(1,1)
      click_button I18n.t('helpers.submit.create')

      # テストデータ4:【新規画面、「優先度＝C」で登録】
      visit new_task_path
      fill_in "name" , with: "data4"
      fill_in "content" , with: "test_step16_data4"
      choose Task.get_priority_name(3,1)
      click_button I18n.t('helpers.submit.create')

      # テスト1:検索画面を表示し、「優先度＝S,A」で検索(新規登録と更新、両方で優先度を設定できることを確認)
      #         データ1:ある。データ2:無い。データ3:ある。データ4:無い。
      visit tasks_path
      check "priority_0"
      check "priority_1"
      find("#tasks_created_at_desc").click
      expect(page).to have_content "test_step16_data1"
      expect(page).not_to have_content "test_step16_data2"
      expect(page).to have_content "test_step16_data3"
      expect(page).not_to have_content "test_step16_data4"

      # テスト2:検索画面を表示し、「優先度＝S,A,B」で検索
      visit tasks_path
      #↓事前登録データがヒットしないよう、「内容詳細」で絞り込む
      fill_in "content" , with: "test_step16"
      check "priority_0"
      check "priority_1"
      check "priority_2"
      #         => 「優先度」でソート（desc:降順(低い順)……C,B,A,S）
      find("#tasks_priority_desc").click
      #         一行目がデータ2、二行目がデータ3、三行目がデータ1
      expect(page).to have_selector '.index_line_0', text: "test_step16_data2"
      expect(page).to have_selector '.index_line_1', text: "test_step16_data3"
      expect(page).to have_selector '.index_line_2', text: "test_step16_data1"

      #         => 「優先度」でソート（asc:昇順(高い順)……S,A,B,C）
      find("#tasks_priority_asc").click
      #         一行目がデータ1、二行目がデータ3、三行目がデータ2
      expect(page).to have_selector '.index_line_0', text: "test_step16_data1"
      expect(page).to have_selector '.index_line_1', text: "test_step16_data3"
      expect(page).to have_selector '.index_line_2', text: "test_step16_data2"

    end

  end
end
