require 'rails_helper'
require 'simplecov'

module TestHelpers
  def login_user
    Capybara.current_session.driver.browser.clear_cookies
    User.delete_all
    @user = User.create(email: 'email@berkeley.edu', password: 'password')
    @user.skip_confirmation!
    @user.save

    visit root_url
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password
    click_button 'Log In'
  end
end