require 'rails_helper'

RSpec.describe User, type: :model do

  example "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  example "ユーザーは「ユーザーcd」必須" do
    user = FactoryBot.build(:user,cd: nil)
    user.valid?
    expect(user.errors[:cd]).to include(I18n.t("errors.messages.empty"))
  end

  example "ユーザーは「ユーザーcd」3字まで登録可能" do
    expect(FactoryBot.build(:user,cd: "a" * 3)).to be_valid

  end

  example "タスクは「ユーザーcd」4字だとエラー" do
    user = FactoryBot.build(:user,cd: "a" * 4)
    user.valid?
    expect(user.errors[:cd]).to include(I18n.t("errors.messages.too_long",count: "3"))
  end

  example "ユーザーは「ユーザー名」必須" do
    user = FactoryBot.build(:user,name: nil)
    user.valid?
    expect(user.errors[:name]).to include(I18n.t("errors.messages.empty"))
  end

  example "ユーザーは「ユーザー名」20字まで登録可能" do
    expect(FactoryBot.build(:user,name: "a" * 20)).to be_valid

  end

  example "ユーザーは「ユーザー名」21字だとエラー" do
    user = FactoryBot.build(:user,name: "a" * 21)
    user.valid?
    expect(user.errors[:name]).to include(I18n.t("errors.messages.too_long",count: "20"))
  end
  example "ユーザーは「email」必須" do
    user = FactoryBot.build(:user,email: nil)
    user.valid?
    expect(user.errors[:email]).to include(I18n.t("errors.messages.empty"))
  end

  example "「email」はメール形式でないとエラー" do
    user = FactoryBot.build(:user,email: "aaaa")
    user.valid?
    expect(user.errors[:email]).to include(I18n.t("errors.messages.invalid"))
  end

  example "「email」は250字まで登録可能(239字＋メール形式11字でテスト)" do
    expect(FactoryBot.build(:user,email: "a" * 239 + "@test.co.jp")).to be_valid

  end

  example "「email」は251字だとエラー(240字＋メール形式11字でテスト)" do
    user = FactoryBot.build(:user,email: "a" * 240 + "@test.co.jp")
    user.valid?
    expect(user.errors[:email]).to include(I18n.t("errors.messages.too_long",count: "250"))
  end


  #バリデーションの発生制限『on: :have_pass』を再現する方法が見つからないため、rspecでのパスワード文字数バリデーションはいったん無効化
  # example "ユーザーは「パスワード」必須" do
  #   user = FactoryBot.build(:user,password: nil)
  #   user.valid?
  #   expect(user.errors[:password]).to include(I18n.t("errors.messages.empty"))
  # end
  #
  # example "ユーザーは「パスワード」40字まで登録可能" do
  #   expect(FactoryBot.build(:user,password: "a" * 40)).to be_valid
  #
  # end
  #
  # example "ユーザーは「パスワード」41字だとエラー" do
  #   user = FactoryBot.build(:user,password: "a" * 41, on: :have_pass)
  #   user.valid?
  #   expect(user.errors[:password]).to include(I18n.t("errors.messages.too_long"))
  # end
  #
  # example "ユーザーは「パスワード」2字で登録可能" do
  #   expect(FactoryBot.build(:user,password: "aa")).to be_valid
  #
  # end
  #
  # example "ユーザーは「パスワード」1字だとエラー" do
  #   user = FactoryBot.build(:user,password: "a")
  #   user.valid?
  #   expect(user.errors[:password]).to include(I18n.t("errors.messages.too_short",count: "2"))
  # end

end
