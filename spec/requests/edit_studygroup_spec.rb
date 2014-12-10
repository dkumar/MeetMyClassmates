require 'rails_helper'
require_relative '../support/test_helpers'
require 'spec_helper'
Capybara.javascript_driver = :poltergeist

describe 'edit page' do
  include TestHelpers

  before :each do
    @user = create_user
    login_user(@user)

    @course = Course.create(title: 'CS61A')

    @owner = User.create(email: 'owner@berkeley.edu', password: 'password')
    @owner.skip_confirmation!
    @owner.save
    @owner.enroll_course(@course.title)

    date = Date.new(2016, 11, 23)

    @studygroup = @owner.create_studygroup('studygroup_name', @course.title, false, Time.utc(2016,"jan",8,12,0,0), Time.utc(2016,"jan",8,12,0,0) + 3600, 'soda', 10, false, false, [], [], date, nil)
    @studygroup.course = @course
    @studygroup.save

    @unscheduled_studygroup = @owner.create_studygroup('unscheduled_studygroup_name', @course.title, true, Time.utc(2016,"jan",8,12,0,0), Time.utc(2016,"jan",8,12,0,0) + 3600, 'soda', 10, false, false, [], [], date, nil)
    @unscheduled_studygroup.course = @course
    @unscheduled_studygroup.save

    @user.enroll_course(@course.title)
    @user.join_studygroup(@studygroup.id)
    @user.join_studygroup(@unscheduled_studygroup.id)

    @non_member_user = create_user
  end


  it 'owner can view edit button' do
    login_user(@owner)
    visit studygroup_show_path(@unscheduled_studygroup)
    page.should have_button('Edit')
  end

  it 'does not allow non owner to view edit button' do
    visit studygroup_show_path(@unscheduled_studygroup)
    page.should have_no_button('Edit')
  end

  it 'owner can edit name' do
    login_user(@owner)
    visit studygroup_show_path(@unscheduled_studygroup)
    click_button 'Edit'
    fill_in 'studygroup_name', with: 'new name'
    click_button 'Save Changes'
    expect(page).to have_content('Success')
    expect(page).to have_content('new name')
  end

  it 'owner can schedule unscheduled group' do
    login_user(@owner)
    visit studygroup_show_path(@unscheduled_studygroup)
    click_button 'Edit'
    select '8', from: 'start_hours'
    select '9', from: 'end_hours'
    click_button 'Schedule Group'
    expect(page).to have_content('Success')
    expect(page).to have_no_button('Unscheduled? No')
  end

  it 'does not allow non owner to view edit button' do
    visit studygroup_show_path(@unscheduled_studygroup)
    page.should have_no_button('Edit')
  end

end
