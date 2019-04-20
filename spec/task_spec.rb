require 'rails_helper'

RSpec.describe Task, type: :model do

  example "get_priority_nameメソッド使用時：第一引数正常値、第二引数なしの場合" do
    expect(Task.get_priority_name(2)).to eq "B"
  end

  example "get_priority_nameメソッド使用時：第一引数正常値、第二引数ありの場合" do
    expect(Task.get_priority_name(3,1)).to eq I18n.t('priority.priority_C')
  end

  example "get_priority_nameメソッド使用時：第一引数異常値、第二引数なしの場合" do
    expect(Task.get_priority_name(22)).to eq I18n.t("errors.messages.is_invalid_info", this: I18n.t('activerecord.attributes.task.priority'))
  end

  example "get_priority_nameメソッド使用時：第一引数異常値、第二引数ありの場合" do
    expect(Task.get_priority_name(10,1)).to eq I18n.t("errors.messages.is_invalid_info", this: I18n.t('activerecord.attributes.task.priority'))
  end

  example "get_status_nameメソッド使用時：引数正常値の場合" do
    expect(Task.get_status_name(0)).to eq I18n.t('status.status_0')
  end

  example "get_status_nameメソッド使用時：引数異常値の場合" do
    expect(Task.get_status_name(22)).to eq  I18n.t("errors.messages.is_invalid_info", this: I18n.t('activerecord.attributes.task.status'))
  end

  example "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:task)).to be_valid
  end

  example "タスクは「ユーザーid」必須" do
    task = FactoryBot.build(:task,user_id: nil)
    task.valid?
    expect(task.errors[:user_id]).to include(I18n.t("errors.messages.empty"))
  end

  example "タスクは「仕事名」必須" do
    task = FactoryBot.build(:task,name: nil)
    task.valid?
    expect(task.errors[:name]).to include(I18n.t("errors.messages.empty"))
  end

  example "タスクは「仕事名」20字まで登録可能" do
    task = FactoryBot.build(:task,name: "a" * 20)
    expect(FactoryBot.build(:task)).to be_valid
  end

  example "タスクは「仕事名」21字だとエラー" do
    task = FactoryBot.build(:task,name: "a" * 21)
    task.valid?
    expect(task.errors[:name]).to include(I18n.t("errors.messages.too_long",count: "20"))
  end

  example "タスクは「仕事内容詳細」「終了期限」無しでも登録可能" do
    task = FactoryBot.build(:task,content: nil,limit: nil)
    expect(FactoryBot.build(:task)).to be_valid
  end

  example "タスクは「仕事内容詳細」120字まで登録可能" do
    task = FactoryBot.build(:task,content: "a" * 120)
    expect(FactoryBot.build(:task)).to be_valid
  end

  example "タスクは「仕事内容詳細」121字だとエラー" do
    task = FactoryBot.build(:task,content: "a" * 121)
    task.valid?
    expect(task.errors[:content]).to include(I18n.t("errors.messages.too_long",count: "120"))
  end

end
