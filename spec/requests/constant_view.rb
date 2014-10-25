require 'rails_helper'
require_relative '../support/test_helpers'
require 'simplecov'
SimpleCov.start 'rails'

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
  include TestHelpers

  before :each do
    login_user
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