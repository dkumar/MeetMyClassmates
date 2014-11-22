require 'rails_helper'
require_relative '../support/test_helpers'
require 'spec_helper'
Capybara.javascript_driver = :poltergeist

describe 'show page' do
  include TestHelpers

  before :each do
    login_user

    @course = Course.create(title: 'CS61A')

    @owner = User.create(email: 'owner@berkeley.edu', password: 'password')
    @owner.skip_confirmation!
    @owner.save
    @owner.enroll_course(@course.title)

    @studygroup = @owner.create_studygroup('studygroup_name', @course.title)
    @studygroup.course = @course
    @studygroup.save

    @user.enroll_course(@course.title)
    @user.join_studygroup(@studygroup.id)
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
    login_owner

    visit studygroup_show_path(@studygroup)
    click_button 'Delete'
    expect(page).to have_content('Success')
  end
end