require 'rails_helper'
require_relative '../support/test_helpers'
require 'simplecov'
SimpleCov.start 'rails'

module ConstantHelperMethods
  def assert_side_bar_visible
    within('#side-bar') do
      expect(page).to have_content('Home'), 'page is %s' % page.body
    end
  end

  def assert_top_bar_visible
    within('#top-bar') do
      expect(page).to have_content('MeetMyClassmates'), 'page is %s' % page.body
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

  before :all do
    @user = User.create(email: 'email@berkeley.edu', password: 'password')
  end

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

  it 'top-bar has User Page link' do
    visit root_url

    find('.last').hover

    within('#top-bar') do
      expect(page).to have_content('User Page'), 'page is %s' % page.body
    end
  end

  it 'top-bar has option to sign out' do
    visit root_url

    find('.last').hover

    within('#top-bar') do
      expect(page).to have_content('User Page'), 'page is %s' % page.body
    end
  end

  # TODO add checks if constant view visible on user page
end