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

    @studygroup = @owner.create_studygroup('studygroup_name', @course.title, false, Time.now, Time.now + 3600, 'soda', 10, 2, false, false, [], [], nil)
    @studygroup.course = @course
    @studygroup.save

    @unscheduled_studygroup = @owner.create_studygroup('unscheduled_studygroup_name', @course.title, true, Time.now, Time.now + 3600, 'soda', 10, 2, false, false, [], [], nil)
    @unscheduled_studygroup.course = @course
    @unscheduled_studygroup.save

    @user.enroll_course(@course.title)
    @user.join_studygroup(@studygroup.id)

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

  it 'allows user to join studygroup' do
    visit studygroup_show_path(@studygroup)
    click_button 'Leave'
    visit studygroup_show_path(@studygroup)
    click_button 'Join'
    expect(page).to have_content('Success')
  end

  it 'allows owner to delete studygroup' do
    login_user(@owner)

    visit studygroup_show_path(@studygroup)
    click_button 'Delete'
    expect(page).to have_content('Success')
  end

  it 'allows user to post a message if user is a member' do
    login_user(@user)
    visit studygroup_show_path(@studygroup)
    text = '123'
    fill_in 'message_body', with: text
    click_button 'Post Message'

    expect(page).to have_content(text)
  end

  it 'allows user to view messages even if user is not a member' do
    login_user(@user)
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
    expect(page).to have_no_content('Post Message')
  end
end