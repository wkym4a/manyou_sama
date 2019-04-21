require 'rails_helper'
require 'date'


RSpec.feature "Projects_step15", type: :feature do
# RSpec.feature "Projects", type: :feature , js: true do
  before do
    #タスク情報登録
    task = FactoryBot.create(:task)
  end


  #############↓タスク機能についてのテスト↓#################1
  ########----↓↓タスク一覧画面テスト↓↓----###########2
  ####--↓↓↓画面遷移テスト↓↓↓3
  scenario "タスク機能関係、画面遷移動作確認……「一覧」→「新規」wteretr" do
    visit tasks_path
    click_link I18n.t('condition.new') + I18n.t('activerecord.models.task')
    # click_button "新規タスク"←bootstrapでボタン化したものは、rspecではボタンとして認識されないっぽい！
    expect(page).to have_content I18n.t('screen.new' ,name:  I18n.t('activerecord.models.task'))
  end

end
