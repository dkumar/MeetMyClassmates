require 'rails_helper'

module TestHelpers
  def login_user
    # clear cookies
    Capybara.current_session.driver.browser.clear_cookies

    visit root_url
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password
    click_button 'Log in'
  end
end