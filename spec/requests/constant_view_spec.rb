require 'rails_helper'
require_relative '../support/test_helpers'
require 'simplecov'
SimpleCov.start 'rails'

module ConstantHelperMethods
  def assert_top_bar_visible
    within ('#top_bar') do
      expect(page).to have_content('MeetMyClassmates'), 'page is %s' % page.body
      expect(page).to have_content('My Study Groups'), 'page is %s' % page.body
      expect(page).to have_content('Unscheduled Study Groups'), 'page is %s' % page.body
      expect(page).to have_content(@user.email), 'page is %s' % page.body
    end
  end
end

describe 'redirect to login if user isn\'t logged in', :type => :request do
  it 'accessing home page if not logged in redirects you to login' do
    visit root_url
    page.should have_button('Log In')
  end
end

describe 'home page' do
  include ConstantHelperMethods
  include TestHelpers

  before :each do
    @user = create_user
    login_user(@user)
  end

  it 'top_bar is visible from home page' do
    visit user_show_path(@user)
    assert_top_bar_visible
  end

  it 'top_bar has User Page link on hover' do
    visit root_url

    within('#top_bar') do
      expect(page).to have_content('User Page'), 'page is %s' % page.body
    end
  end

  it 'top_bar has option to Sign Out on hover' do
    visit root_url

    within('#top_bar') do
      expect(page).to have_content('Sign Out'), 'page is %s' % page.body
    end
  end

  it 'top_bar shows all users studygroups on (my studygroups) hover' do
    visit root_url
    within('#top_bar') do
      @user.studygroups.each do |studygroup|
        expect(page).to have_content(studygroup.name)
      end
    end
  end

  it 'top_bar shows all users courses on (unscheduled) hover' do
    visit root_url
    within('#top_bar') do
      @user.courses.each do |course|
        expect(page).to have_content(course.title)
      end
    end
  end
end