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

end
