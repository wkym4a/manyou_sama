require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  before do
    #タスク情報登録
    task = FactoryBot.create(:task)
  end

  #############↓タスク機能についてのテスト↓#################1
  ########----↓↓タスク一覧画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「一覧」→「新規」" do
    visit tasks_path
    click_link "新規タスク"
    # click_button "新規タスク"←bootstrapでボタン化したものは、rspecではボタンとして認識されないっぽい！
    expect{
    expect(page).to have_content "新規タスク画面" }
  end

  scenario "タスク機能関係、画面遷移動作確認……「一覧」→「更新」" do

    #タスク情報登録
    task2 = FactoryBot.create(:task,name: "タスク登録データ確認、名称")
    task3 = FactoryBot.create(:task,name: "ダミー")

    visit tasks_path
    click_link "goto_task" + task2.id.to_s + "_edit"

    expect{
    expect(page).to have_content "タスク編集画面"
    expect(page).to have_content task2.name
          }
  end

  scenario "タスク機能関係、画面遷移動作確認……「一覧」→「閲覧」" do

    #タスク情報登録
    task2 = FactoryBot.create(:task,name: "タスク登録データ確認、名称")
    task3 = FactoryBot.create(:task,name: "ダミー")

    visit tasks_path
    click_link "goto_task" + task2.id.to_s + "_show"

    expect{
    expect(page).to have_content "タスク閲覧画面"
    expect(page).to have_content task2.name
          }
  end

  ####--↑↑↑画面遷移テスト↑↑↑3


  ####--↓↓↓画面表示テスト↓↓↓3
  scenario "「タスク一覧」画面動作確認、登録したデータが一覧に表示されている" do
    visit tasks_path

    expect{
      #登録したデータ（の、仕事名）が表示されている
    expect(page).to have_content task.name }
  end
  ####--↑↑↑画面表示テスト↑↑↑3
  ########----↑↑タスク一覧画面テスト↑↑----###########2



  ########----↓↓新規タスク登録画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「新規」→戻る→「一覧」" do
    visit new_task_path
    click_link "戻る"
    expect{
    expect(page).to have_content "タスク一覧画面" }
  end
  ####--↑↑↑画面遷移テスト↑↑↑

  ####--↓↓↓登録テスト↓↓↓3
  scenario "何も入力しないで登録するとエラー" do
    visit new_task_path
    click_button "登録する"

    expect{
    expect(page).to have_content "新規タスク画面"
    expect(page).to have_content "登録に失敗しました" }
  end


  scenario "タスク名だけ入力して登録すると登録成功" do
    visit new_task_path
    fill_in "name" ,with: "新規登録データのタスク名"

    expect{
    click_button "登録する"

    expect(page).to have_content "タスク編集画面"
    expect(page).to have_content "登録に成功しました"
  }.to change(Task.all, :count).by(1)

  end
  ####--↑↑↑登録テスト↑↑↑3
  ########----↑↑新規タスク登録画面テスト↑↑----###########2


  ########----↓↓タスク更新画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「更新」→戻る→「一覧」" do

    task = FactoryBot.create(:task)
    visit edit_task_path(task.id)
    click_link "戻る"
    expect{
    expect(page).to have_content "タスク一覧画面" }
  end
  ####--↑↑↑画面遷移テスト↑↑↑


  ####--↓↓↓登録テスト↓↓↓3

  #更新時、名前変更不可とするつもり（デザイン調整時に実装）なので名前ではなく詳細変更で試験
  scenario "詳細を入力して更新" do
    task = FactoryBot.create(:task)
    visit edit_task_path(task.id)
    fill_in "content" ,with: "仕事の詳細を変更"

    expect{
    click_button "登録する"

    expect(page).to have_content "更新に成功しました"

    click_link "戻る"

    expect(page).to have_content "タスク一覧画面"
    expect(page).to have_content "仕事の詳細を変更"
  }.to change(Task.all, :count).by(0)

    end


    scenario "データ削除" do
      task = FactoryBot.create(:task ,name: "削除予定のデータ")
      visit edit_task_path(task.id)
      fill_in "content" ,with: "仕事の詳細を変更"

      expect{
      click_link "削除する"

      #  click_button "OK"
      #……↑【「確認画面表示」→「キャンセル」「OK」で「OK」だと削除】は省略される模様

      expect(page).to have_content "タスクを削除しました"

      expect(page).to have_content "タスク一覧画面"
      expect(page).not_to have_content "削除予定のデータ"
    }.to change(Task.all, :count).by(-1)

      end
    ####--↑↑↑登録テスト↑↑↑3

    ########----↓↓タスク閲覧画面テスト↓↓----###########2
    ####--↓↓↓画面遷移テスト↓↓↓3
    scenario "タスク機能関係、画面遷移動作確認……「閲覧」→戻る→「一覧」" do

      task = FactoryBot.create(:task)
      visit task_path(task.id)
      click_link "戻る"
      expect{
      expect(page).to have_content "タスク一覧画面" }
    end
    ####--↑↑↑画面遷移テスト↑↑↑
    ########----↑↑タスク閲覧画面テスト↑↑----###########2


end
