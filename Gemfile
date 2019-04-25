source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# ↓「ruby -v」によるバージョン情報↓
# ruby 2.6.2p47 (2019-03-13 revision 67232) [x86_64-darwin18]

gem 'rails', '~> 5.2.3'

gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

#bootstrapをgemで追加
# gem 'bootstrap', '~> 4.1.1'
gem 'jquery-rails'

#日付をカレンダーで制御するため
gem "bootstrap4-datetime-picker-rails"
gem 'momentjs-rails'
gem "font-awesome-rails"

#step17で追加
gem 'kaminari'

#ログインパスワード管理用
gem 'bcrypt', '3.1.11'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'spring'

  #20190412 add
  gem 'spring-commands-rspec'


  # gem 'capybara', '2.2.0' #2.2.0に修正
  #2019412 change(「参考資料」のバージョンに合わせた)
  gem 'capybara', '~> 2.15.2'
  # #gem 'capybara', '~> 2.13'

  gem 'selenium-webdriver'

  # 開発、検証用に追加
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'

    #テスト用のジェム
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem 'faker'

  #テストデータ作成用
  gem 'faker'
end

group :test do
  #テスト後、データをクリアするジェム
  gem 'database_cleaner'

    #テスト用のジェム 20190412 add
  gem 'launchy'
  gem 'webdrivers'

  # #js下でのdb更新用？
  # gem "capybara-webkit"
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring-watcher-listen', '~> 2.0.0'

end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
