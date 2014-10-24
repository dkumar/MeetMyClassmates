require 'rails_helper'
require_relative '../support/test_helpers'

describe UsersController do
  include TestHelpers

  before :all do
    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)
  end

  before :each do
    login_user
  end

  it 'enrolls in a course' do
    post enroll_course_path, :course => @course.title
    visit user_show_path(@user)
    expect(page).to have_content(@course.title)
  end

  it 'unenrolls from a course' do
    post enroll_course_path, :course => @course.title
    post unenroll_course_path, :course => @course.title
    get user_show_path(@user)
    expect(page).to have_no_content(@course.title)
  end
end