require 'rails_helper'
require 'simplecov'

module TestHelpers
  def login_user(user)
    Capybara.current_session.driver.browser.clear_cookies

    visit root_url
    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => user.password
    click_button 'Log In'
  end

  def create_user
    user = User.create(email: "#{rand(32**8).to_s(32)}@berkeley.edu", password: 'password')
    user.skip_confirmation!
    user.save
    user
  end
end