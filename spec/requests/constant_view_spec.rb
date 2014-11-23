require 'rails_helper'
require_relative '../support/test_helpers'
require 'simplecov'
SimpleCov.start 'rails'

module ConstantHelperMethods
  def assert_drop_down_visible
    expect(page).to have_content('MeetMyClassmates'), 'page is %s' % page.body

    within('#drop_down') do
      expect(page).to have_content(@user.email), 'page is %s' % page.body
    end
  end
end

describe 'redirect to login if user isn\'t logged in', :type => :request do
  it 'accessing home page if not logged in redirects you to login' do
    visit root_url
    expect(page).to have_content('Log In'), 'page is %s' % page.body
  end
end

describe 'home page' do
  include ConstantHelperMethods
  include TestHelpers

  before :each do
    @user = create_user
    login_user(@user)
  end

  it 'drop_down has User Page link on hover' do
    visit root_url

    within('#drop_down') do
      expect(page).to have_content('User Page'), 'page is %s' % page.body
    end
  end

  it 'drop_down has option to Sign Out on hover' do
    visit root_url

    within('#drop_down') do
      expect(page).to have_content('Sign Out'), 'page is %s' % page.body
    end
  end

  it 'drop_down is visible from home page' do
    visit user_show_path(@user)
    assert_drop_down_visible
  end
end