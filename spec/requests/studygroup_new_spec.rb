require 'rails_helper'
require_relative '../support/test_helpers'
require 'spec_helper'
require 'simplecov'
Capybara.javascript_driver = :poltergeist

module HelperMethods
  def enroll_in_course(course_title)
  end
end

describe 'create page' do
  include HelperMethods
  include TestHelpers

  before :each do
    course_title = 'CS61A'
    Course.create(title: course_title)
    @user = create_user
    login_user(@user)
    rtn_code = @user.enroll_course(course_title)
    expect(rtn_code).to eq(GlobalConstants::SUCCESS)
  end

  it 'show error for good data' do
    visit new_studygroup_path
    fill_in('groupname', :with => "anything")
   	select "9", :from => "start_hours"
   	select "30", :from => "start_minutes"
   	select "P.M.", :from => "start_time_tag"
   	select "10", :from => "end_hours"
   	select "30", :from => "end_minutes"
   	select "P.M.", :from => "end_time_tag"
    fill_in('date', :with => '2011/01/01')
    fill_in('location', :with => "anywhere")
    fill_in('course', :with => "CS61A")
    click_button('Create')
    expect(page).to have_content 'Success'
  end

  it 'error for no course' do
    visit new_studygroup_path
    fill_in('groupname', :with => "anything")
    select "9", :from => "start_hours"
    select "30", :from => "start_minutes"
    select "P.M.", :from => "start_time_tag"
    select "10", :from => "end_hours"
    select "30", :from => "end_minutes"
    select "P.M.", :from => "end_time_tag"
    fill_in('date', :with => '2011/01/01')
    fill_in('location', :with => "anywhere")
    click_button('Create')
  end

  it 'error for no studygroup name' do
    visit new_studygroup_path
    select "9", :from => "start_hours"
    select "30", :from => "start_minutes"
    select "P.M.", :from => "start_time_tag"
    select "10", :from => "end_hours"
    select "30", :from => "end_minutes"
    select "P.M.", :from => "end_time_tag"
    fill_in('date', :with => '2011/01/01')
    fill_in('location', :with => "anywhere")
    fill_in('course', :with => "CS61A")
    click_button('Create')
  end

  it 'error for no studygroup date' do
    visit new_studygroup_path
    fill_in('groupname', :with => "anything")
    select "9", :from => "start_hours"
    select "30", :from => "start_minutes"
    select "P.M.", :from => "start_time_tag"
    select "10", :from => "end_hours"
    select "30", :from => "end_minutes"
    select "P.M.", :from => "end_time_tag"
    fill_in('location', :with => "anywhere")
    fill_in('course', :with => "CS61A")
    click_button('Create')
    expect(page).to have_content 'Error: Please Enter a date.'
  end
end