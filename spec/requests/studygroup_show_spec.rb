require 'rails_helper'
require_relative '../support/test_helpers'
require 'spec_helper'
Capybara.javascript_driver = :poltergeist

describe 'show page' do
  include TestHelpers

  before :each do
    @user = create_user
    login_user(@user)

    @course = Course.create(title: 'CS61A')

    @owner = User.create(email: 'owner@berkeley.edu', password: 'password')
    @owner.skip_confirmation!
    @owner.save
    @owner.enroll_course(@course.title)

    @studygroup = @owner.create_studygroup('studygroup_name', @course.title, false, Time.utc(2000,"jan",1,12,0,0), Time.utc(2000,"jan",1,12,0,0) + 3600, 'soda', 10, false, false, [], [], nil)
    @studygroup.course = @course
    @studygroup.save

    @unscheduled_studygroup = @owner.create_studygroup('unscheduled_studygroup_name', @course.title, true, Time.utc(2000,"jan",1,12,0,0), Time.utc(2000,"jan",1,12,0,0) + 3600, 'soda', 10, false, false, [], [], nil)
    @unscheduled_studygroup.course = @course
    @unscheduled_studygroup.save

    @user.enroll_course(@course.title)
    @user.join_studygroup(@studygroup.id)
    @user.join_studygroup(@unscheduled_studygroup.id)


    @non_member_user = create_user
  end

  it 'displays information of the studygroup' do
    visit studygroup_show_path(@studygroup)
    expect(page).to have_content(@studygroup.name)
    expect(page).to have_content(@course.title)
  end

  it 'allows user to leave studygroup' do
    visit studygroup_show_path(@studygroup)
    click_button 'Leave'
    expect(page).to have_content('Success')
  end

  it 'allows user to leave unscheduled studygroup' do
    visit studygroup_show_path(@unscheduled_studygroup)
    click_button 'Leave'
    expect(page).to have_content('Success')
  end

  it 'allows user to join studygroup' do
    visit studygroup_show_path(@studygroup)
    click_button 'Leave'
    visit studygroup_show_path(@studygroup)
    click_button 'Join'
    expect(page).to have_content('Success')
  end

  it 'allows user to join an unscheduled studygroup' do
    visit studygroup_show_path(@unscheduled_studygroup)
    click_button 'Leave'
    visit studygroup_show_path(@unscheduled_studygroup)
    click_button 'Join'
    expect(page).to have_content('Success')
  end

  it 'does not allow users to delete studygroup if not owner' do
    visit studygroup_show_path(@studygroup)
    page.should have_no_button('Delete')
  end

  it 'does not allow users to delete unscheduled studygroup if not owner' do
    visit studygroup_show_path(@unscheduled_studygroup)
    page.should have_no_button('Delete')
  end

  it 'allows owner to delete studygroup' do
    login_user(@owner)
    visit studygroup_show_path(@studygroup)
    click_button 'Delete'
    expect(page).to have_content('Success')
  end

  it 'allows owner to delete unscheduled studygroup' do
    login_user(@owner)
    visit studygroup_show_path(@unscheduled_studygroup)
    click_button 'Delete'
    expect(page).to have_content('Success')
  end

  it 'allows user to post a message if user is a member' do
    visit studygroup_show_path(@studygroup)
    text = '123'
    fill_in 'message_body', with: text
    click_button 'Post Message'
    expect(page).to have_content(text)
  end

  it 'allows user to view messages even if user is not a member' do
    visit studygroup_show_path(@studygroup)
    text = 'abc'
    fill_in 'message_body', with: text
    click_button 'Post Message'
    login_user(@non_member_user)
    visit studygroup_show_path(@studygroup)
    expect(page).to have_content(text)
  end

  it 'does not allow non members to post a message ' do
    login_user(@non_member_user)
    visit studygroup_show_path(@studygroup)
    page.should have_no_button('Post Message')
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

end