require 'rails_helper'

module ConstantHelperMethods
  def assert_side_bar_visible
    within('#side-bar') do
      expect(page).to have_content('Home')
    end
  end

  def assert_top_bar_visible
    within('#top-bar') do
      expect(page).to have_content('MeetMyClassmates')
      expect(page).to have_content(@user_email)
    end
  end
end

describe 'redirect to login if user isn\'t logged in', :type => :request do
  it 'accessing home page if not logged in redirects you to login' do
    visit root_url
    expect(page).to have_content('Log in'), 'page is %s' % page.body
  end
end

describe 'home page', :type => :request do
  include ConstantHelperMethods

  before :each do
    # clear cookies
    Capybara.current_session.driver.browser.clear_cookies

    @user_email = 'test@berkeley.edu'
    @user_password = '12345678'
    User.create(email: @user_email, password: @user_password)

    visit root_url
    fill_in 'user_email', :with => @user_email
    fill_in 'user_password', :with => @user_password
    click_button 'Log in'
  end

  it 'side-bar is visible from home page' do
    visit root_url
    assert_side_bar_visible
  end

  it 'top-bar is visible from home page' do
    visit root_url
    assert_top_bar_visible
  end

  # TODO add checks if constant view visible on user page
end