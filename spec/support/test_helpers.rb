require 'rails_helper'

module TestHelpers
  def login_user
    Capybara.current_session.driver.browser.clear_cookies
    @user = User.create(email: 'email@berkeley.edu', password: 'password')
    @user.skip_confirmation!
    @user.save

    visit root_url
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password
    click_button 'Log In'
  end

  def login_owner
    Capybara.current_session.driver.browser.clear_cookies

    visit root_url
    fill_in 'user_email', :with => @owner.email
    fill_in 'user_password', :with => @owner.password
    click_button 'Log In'
  end
end