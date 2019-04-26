module LoginSupport
  def sign_in_as(user)

    visit new_session_path
    fill_in "cd", with: user.cd
    fill_in "password", with: user.password
    click_button "Log in"

  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
