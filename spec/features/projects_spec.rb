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
    click_link I18n.t('condition.new') + I18n.t('activerecord.models.task')
    # click_button "新規タスク"←bootstrapでボタン化したものは、rspecではボタンとして認識されないっぽい！
    expect(page).to have_content I18n.t('screen.new' ,name:  I18n.t('activerecord.models.task'))
  end

  scenario "タスク機能関係、画面遷移動作確認……「一覧」→「更新」" do

    #タスク情報登録
    task2 = FactoryBot.create(:task,content: "タスク登録データ確認、内容詳細")
    task3 = FactoryBot.create(:task,content: "ダミー")

    visit tasks_path
    click_link "goto_task" + task2.id.to_s + "_edit"

    expect(page).to have_content I18n.t('screen.edit' ,name:  I18n.t('activerecord.models.task'))
    expect(page).to have_content task2.content

  end

  scenario "タスク機能関係、画面遷移動作確認……「一覧」→「閲覧」" do

    #タスク情報登録
    task2 = FactoryBot.create(:task,content: "abcdefg")
    task3 = FactoryBot.create(:task,content: "dummy")

    visit tasks_path
    click_link "goto_task" + task2.id.to_s + "_show"

    expect(page).to have_content I18n.t('screen.show' ,name:  I18n.t('activerecord.models.task'))
    expect(page).to have_content task2.content
  end
  ####--↑↑↑画面遷移テスト↑↑↑3

  ####--↓↓↓画面表示テスト↓↓↓3
  scenario "「タスク一覧」画面動作確認、登録したデータが一覧に表示されている" do

    #タスク情報登録
    task2 = FactoryBot.create(:task,content: "content_content_content_content")

    visit tasks_path

    #登録したデータ（の、仕事名）が表示されている
    expect(page).to have_content task2.content
  end
  ####--↑↑↑画面表示テスト↑↑↑3
  ########----↑↑タスク一覧画面テスト↑↑----###########2

  ########----↓↓新規タスク登録画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「新規」→戻る→「一覧」" do
    visit new_task_path
    click_link I18n.t('condition.back')
    expect(page).to have_content  I18n.t('screen.index' ,name:  I18n.t('activerecord.models.task'))
  end
  ####--↑↑↑画面遷移テスト↑↑↑3

  ####--↓↓↓登録テスト↓↓↓3
  scenario "何も入力しないで登録するとエラー" do
    visit new_task_path
    click_button I18n.t('helpers.submit.create')

    expect(page).to have_content I18n.t('screen.new',name: I18n.t('activerecord.models.task'))
    expect(page).to have_content I18n.t('activerecord.errors.messages.failed_save')
  end

  scenario "タスク名だけ入力して登録すると登録成功" do
    visit new_task_path
    fill_in "name" ,with: "abababab"

    expect{
      click_button I18n.t('helpers.submit.create')

      expect(page).to have_content I18n.t('screen.edit',name: I18n.t('activerecord.models.task'))
      expect(page).to have_content I18n.t('activerecord.normal_process.do_save')
          }.to change(Task.all, :count).by(1)
  end
  ####--↑↑↑登録テスト↑↑↑3
  ########----↑↑新規タスク登録画面テスト↑↑----###########2

  ########----↓↓タスク更新画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「更新」→戻る→「一覧」" do

    task = FactoryBot.create(:task)
    visit edit_task_path(task.id)
    click_link I18n.t('condition.back')
    expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
  end
  ####--↑↑↑画面遷移テスト↑↑↑3

  ####--↓↓↓登録テスト↓↓↓3
  #更新時、名前変更不可とするつもり（デザイン調整時に実装）なので名前ではなく詳細変更で試験
  scenario "詳細を入力して更新" do
    task = FactoryBot.create(:task)
    visit edit_task_path(task.id)
    fill_in "content" ,with: "change_taskcontent_changechange"

    expect{
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content I18n.t('activerecord.normal_process.do_update')
      click_link I18n.t('condition.back')
      expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
      expect(page).to have_content "change_taskcontent_changechange"
          }.to change(Task.all, :count).by(0)
  end

  scenario "データ削除" do
    task = FactoryBot.create(:task ,name: "this_will_del")
    visit edit_task_path(task.id)

    expect{
      click_link I18n.t('helpers.submit.delete')
      #  click_button "OK"
      #……↑【「確認画面表示」→「キャンセル」「OK」で「OK」だと削除】は省略される模様

      expect(page).to have_content I18n.t('activerecord.normal_process.do_del',this: I18n.t('activerecord.models.task'))
      expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
      expect(page).not_to have_content "this_will_del"
          }.to change(Task.all, :count).by(-1)
  end
  ####--↑↑↑登録テスト↑↑↑3

  ########----↓↓タスク閲覧画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「閲覧」→戻る→「一覧」" do

    task = FactoryBot.create(:task)
    visit task_path(task.id)
    click_link I18n.t('condition.back')
    expect(page).to have_content I18n.t('screen.index',name: I18n.t('activerecord.models.task'))
  end
  ####--↑↑↑画面遷移テスト↑↑↑3
  ########----↑↑タスク閲覧画面テスト↑↑----###########2
  #############↑タスク機能についてのテスト↑#################1

end
