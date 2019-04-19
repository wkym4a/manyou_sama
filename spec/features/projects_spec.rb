require 'rails_helper'

RSpec.feature "Projects", type: :feature , js: true do
# RSpec.feature "Projects", type: :feature do

  before do
    #タスク情報登録
    task = FactoryBot.create(:task)
  end


  scenario "テスト用のテスト1", js: true do

        visit tasks_path
 save_and_open_page
        expect(page).to have_content "tttt_test"
  end
 

  scenario "テスト用のテスト2", js: true do

        visit tasks_path

        click_button I18n.t('action.search')
        #↑クリック自体は成功。
        # ・検索→結果を非同期で再表示（「views」の下にある「.js.erb」ファイルを読み込んで画面の書き換え）はやっている。
        #　テスト用に用意した「画面上の文字をtttt_test→eeee_test書き換え】（画面ロード時、「assets」の下にある「.js」ファイルで作られるイベントは発生していない


        # click_button "この文言が検索ボタンです"
        #find("#btn_search_tasks").click
        #click_button I18n.t('action.search')
        sleep 4
save_and_open_page
        expect(page).to have_content "eeee_test"
  end

  scenario "テスト用のテスト2-2", js: true do

        visit tasks_path

find("#btn_search_tasks").click
        #↑「click_button」を「find("#btn_search_tasks").click」に変更しても、結果は全く同じ

        sleep 4
save_and_open_page
        expect(page).to have_content "eeee_test"
  end

  #
  #
  #
  # #############↓タスク機能についてのテスト↓#################1
  # ########----↓↓タスク一覧画面テスト↓↓----###########2
  # ####--↓↓↓画面遷移テスト↓↓↓3
  # scenario "タスク機能関係、画面遷移動作確認……「一覧」→「新規」" do
  #   visit tasks_path
  #   click_link I18n.t('condition.new') + I18n.t('activerecord.models.task')
  #   # click_button "新規タスク"←bootstrapでボタン化したものは、rspecではボタンとして認識されないっぽい！
  #   expect(page).to have_content I18n.t('screen.new' ,name:  I18n.t('activerecord.models.task'))
  # end
  #
  # scenario "タスク機能関係、画面遷移動作確認……「一覧」→「更新」(一覧画面、条件無しで検索してから)", js: true do
  #   #↑
  #   #[js: true do]→jsの動作に対応するため追記……『RspecによるRailsテスト入門』、104〜106頁あたり参照
  #
  #   #タスク情報登録
  #   task2 = FactoryBot.create(:task,content: "タスク登録データ確認、内容詳細")
  #   task3 = FactoryBot.create(:task,content: "ダミー")
  #
  #   visit tasks_path
  #   #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
  #   #(step14にて、クリックするボタンを変更)
  #   find_by_id('tasks_created_at_desc').click
  #   find("#tasks_created_at_desc").click
  #   #click_button I18n.t('action.search')
  #   sleep 4
  #
  #   click_link "goto_task" + task2.id.to_s + "_edit"
  #
  #   expect(page).to have_content I18n.t('screen.edit' ,name:  I18n.t('activerecord.models.task'))
  #   expect(page).to have_content task2.content
  #
  # end
  #
  # scenario "タスク機能関係、画面遷移動作確認……「一覧」→「閲覧」(一覧画面、条件無しで検索してから)", js: true do
  #
  #   #タスク情報登録
  #   task2 = FactoryBot.create(:task,content: "abcdefg")
  #   task3 = FactoryBot.create(:task,content: "dummy")
  #
  #   visit tasks_path
  #   #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
  #   #(step14にて、クリックするボタンを変更)
  #   find("#tasks_created_at_desc").click
  #   #click_button I18n.t('action.search')
  #   sleep 4
  #
  #   click_link "goto_task" + task2.id.to_s + "_show"
  #
  #   expect(page).to have_content I18n.t('screen.show' ,name:  I18n.t('activerecord.models.task'))
  #   expect(page).to have_content task2.content
  # end
  # ####--↑↑↑画面遷移テスト↑↑↑3
  #
  # ####--↓↓↓画面表示テスト↓↓↓3
  # scenario "「タスク一覧」画面動作確認、登録したデータが一覧に表示されている(一覧画面、条件無しで検索してから)", js: true do
  #
  #   #タスク情報登録
  #   task2 = FactoryBot.create(:task,content: "content_content_content_content")
  #
  #   visit tasks_path
  #   #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
  #   #(step14にて、クリックするボタンを変更)
  #   find("#tasks_created_at_desc").click
  #   #click_button I18n.t('action.search')
  #   sleep 4
  #
  #   #登録したデータ（の、仕事名）が表示されている
  #   expect(page).to have_content task2.content
  # end
  #
  # scenario "登録したデータが作成日時順に表示されている（step11対応のための追加改修）(一覧画面、条件無しで検索してから)", js: true do
  #
  #   #テスト用に、タイムスタンプの自動設定をoffに
  #   ActiveRecord::Base.record_timestamps = false
  #
  #   #タスク情報登録
  #   #「作成日時が明日であるデータ」を先に登録
  #   task_tomorrow = FactoryBot.create(:task,content: "create_tomorrow",
  #     created_at: Time.now.tomorrow ,updated_at: Time.now.tomorrow)
  #   #「作成日時が現在であるデータ」を後に2回登録
  #   task_now_1 = FactoryBot.create(:task,content: "create_now_1",
  #     created_at: Time.now ,updated_at: Time.now)
  #   task_now_2 = FactoryBot.create(:task,content: "create_now_2",
  #     created_at: Time.now ,updated_at: Time.now)
  #
  #   #他のテストに影響を与えないよう、タイムスタンプの自動設定をonに戻す
  #   ActiveRecord::Base.record_timestamps = true
  #
  #   visit tasks_path
  #   #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
  #   #(step14にて、クリックするボタンを変更)
  #   find("#tasks_created_at_desc").click
  #   #click_button I18n.t('action.search')
  #   sleep 4
  #
  #   #一行目（line_0）→初めに登録した「task_tomorrow」……∵、作成日時は「明日」
  #   #二行目（line_1）→最後に登録した「task_now_2」……∵、作成日時は「【task_now_1】よりも後」
  #   #三行目（line_2）→二番目に登録した「task_now_1」
  #   # sleep 5
  #   # save_and_open_page
  #   expect(page).to have_selector '.index_line_0', text:  task_tomorrow.content
  #   expect(page).to have_selector '.index_line_1', text:  task_now_2.content
  #   expect(page).to have_selector '.index_line_2', text:  task_now_1.content
  #
  # end
  #
  # ####--↑↑↑画面表示テスト↑↑↑3
  # ########----↑↑タスク一覧画面テスト↑↑----###########2
  #
  # ########----↓↓新規タスク登録画面テスト↓↓----###########2
  # ####--↓↓↓画面遷移テスト↓↓↓3
  # scenario "タスク機能関係、画面遷移動作確認……「新規」→戻る→「一覧」" do
  #   visit new_task_path
  #   click_link I18n.t('condition.back')
  #   expect(page).to have_content  I18n.t('screen.index' ,name:  I18n.t('activerecord.models.task'))
  # end
  # ####--↑↑↑画面遷移テスト↑↑↑3
  #
  # ####--↓↓↓登録テスト↓↓↓3
  # scenario "何も入力しないで登録するとエラー" do
  #   visit new_task_path
  #   click_button I18n.t('helpers.submit.create')
  #
  #   expect(page).to have_content I18n.t('screen.new',name: I18n.t('activerecord.models.task'))
  #   expect(page).to have_content I18n.t('errors.template.header.none')
  # end
  #
  # scenario "タスク名だけ入力して登録すると登録成功" do
  #   visit new_task_path
  #   fill_in "name" ,with: "abababab"
  #
  #   expect{
  #     click_button I18n.t('helpers.submit.create')
  #
  #     expect(page).to have_content I18n.t('screen.edit',name: I18n.t('activerecord.models.task'))
  #     expect(page).to have_content I18n.t('activerecord.normal_process.do_save')
  #         }.to change(Task.all, :count).by(1)
  # end
  # ####--↑↑↑登録テスト↑↑↑3
  # ########----↑↑新規タスク登録画面テスト↑↑----###########2
  #
  # ########----↓↓タスク更新画面テスト↓↓----###########2
  # ####--↓↓↓画面遷移テスト↓↓↓3
  # scenario "タスク機能関係、画面遷移動作確認……「更新」→戻る→「一覧」" do
  #
  #   task = FactoryBot.create(:task)
  #   visit edit_task_path(task.id)
  #   click_link I18n.t('condition.back')
  #   expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
  # end
  # ####--↑↑↑画面遷移テスト↑↑↑3
  #
  # ####--↓↓↓登録テスト↓↓↓3
  # #更新時、名前変更不可とするつもり（デザイン調整時に実装）なので名前ではなく詳細変更で試験
  # scenario "詳細を入力して更新(一覧画面、条件無しで検索してから)", js: true do
  #   task = FactoryBot.create(:task)
  #   visit edit_task_path(task.id)
  #   fill_in "content" ,with: "change_taskcontent_changechange"
  #
  #   expect{
  #     click_button I18n.t('helpers.submit.create')
  #     expect(page).to have_content I18n.t('activerecord.normal_process.do_update')
  #     click_link I18n.t('condition.back')
  #     #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
  #     #(step14にて、クリックするボタンを変更)
  #     find("#tasks_created_at_desc").click
  #     #click_button I18n.t('action.search')
  #     sleep 4
  #
  #     expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
  #     expect(page).to have_content "change_taskcontent_changechange"
  #         }.to change(Task.all, :count).by(0)
  # end
  #
  # scenario "データ削除(一覧画面、条件無しで検索してから)", js: true do
  #   task = FactoryBot.create(:task ,name: "this_will_del")
  #   visit edit_task_path(task.id)
  #
  #   expect{
  #     click_link I18n.t('helpers.submit.delete')
  #     #  click_button "OK"
  #     #……↑【「確認画面表示」→「キャンセル」「OK」で「OK」だと削除】は省略される模様
  #     #↓js有効時には↑は省略されないようなので、「OK」ボタンも押してやる必要がある
  #     page.driver.browser.switch_to.alert.accept
  #     #click_button 'OK'
  #     #click_link 'OK'
  #
  #     #↓一覧画面は初期表示だと検索されていないので、いったん「条件なしで検索」してから情報の存在をチェックする
  #     #(step14にて、クリックするボタンを変更)
  #     find("#tasks_created_at_desc").click
  #     #click_button I18n.t('action.search')
  #     sleep 4
  #
  #     expect(page).to have_content I18n.t('activerecord.normal_process.do_del',this: I18n.t('activerecord.models.task'))
  #     expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
  #     expect(page).not_to have_content "this_will_del"
  #         }.to change(Task.all, :count).by(-1)
  # end
  # ####--↑↑↑登録テスト↑↑↑3
  #
  # ########----↓↓タスク閲覧画面テスト↓↓----###########2
  # ####--↓↓↓画面遷移テスト↓↓↓3
  # scenario "タスク機能関係、画面遷移動作確認……「閲覧」→戻る→「一覧」" do
  #
  #   task = FactoryBot.create(:task)
  #   visit task_path(task.id)
  #   click_link I18n.t('condition.back')
  #   expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
  # end
  # ####--↑↑↑画面遷移テスト↑↑↑3
  # ########----↑↑タスク閲覧画面テスト↑↑----###########2
  # #############↑タスク機能についてのテスト↑#################1
  #
  # # save_and_open_page

end
