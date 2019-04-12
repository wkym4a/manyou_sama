require 'rails_helper'

RSpec.describe Task, type: :model do

  example "get_priority_nameメソッド使用時：第一引数正常値、第二引数なしの場合" do
    expect(Task.get_priority_name(2)).to eq "B"
  end

  example "get_priority_nameメソッド使用時：第一引数正常値、第二引数ありの場合" do
    expect(Task.get_priority_name(3,1)).to eq "C……後回し可能"
  end

  example "get_priority_nameメソッド使用時：第一引数異常値、第二引数なしの場合" do
    expect(Task.get_priority_name(22)).to eq "「優先度」情報が不正です。"
  end

  example "get_priority_nameメソッド使用時：第一引数異常値、第二引数ありの場合" do
    expect(Task.get_priority_name(10,1)).to eq "「優先度」情報が不正です。"
  end

  example "get_status_nameメソッド使用時：引数正常値の場合" do
    expect(Task.get_status_name(0)).to eq "未着手"
  end

  example "get_status_nameメソッド使用時：引数異常値の場合" do
    expect(Task.get_status_name(22)).to eq "「進捗状態」情報が不正です。"
  end

  example "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:task)).to be_valid
  end


  example "タスクは「ユーザーid」必須" do
    task = FactoryBot.build(:task,user_id: nil)
    task.valid?
    expect(task.errors[:user_id]).to include("can't be blank")
  end

  example "タスクは「仕事名」必須" do
    task = FactoryBot.build(:task,name: nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end

  example "タスクは「仕事名」20字まで登録可能" do
    task = FactoryBot.build(:task,name: "a" * 20)
    expect(FactoryBot.build(:task)).to be_valid
  end
  example "タスクは「仕事名」21字だとエラー" do
    task = FactoryBot.build(:task,name: "a" * 21)
    task.valid?
    expect(task.errors[:name]).to include("is too long (maximum is 20 characters)")
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
    expect(task.errors[:content]).to include("is too long (maximum is 120 characters)")
  end



end
