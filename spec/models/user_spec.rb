require 'rails_helper'

describe User do
  before :each do
    User.delete_all
    Studygroup.delete_all
    Course.delete_all

    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)
    @owner = FactoryGirl.create(:user)
  end

  it 'enrolling in a valid class that user is not enrolled in' do
    rtn_value = User.enroll_course(@user, @course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)
  end

  it 'attempting to enroll in invalid class' do
    rtn_value = User.enroll_course(@user, '1')
    expect(rtn_value).to eq(GlobalConstants::COURSE_NONEXISTENT)
  end

  it 'attempting to enroll in class user is already enrolled in' do
    User.enroll_course(@user, @course.title)
    rtn_value = User.enroll_course(@user, @course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_ALREADY_ENROLLED)
  end

  it 'user unenrolls in a course they are previously enrolled in' do
    User.enroll_course(@user, @course.title)
    rtn_value = User.unenroll_course(@user, @course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)
  end

  it 'user unenrolls in a class that doesn\t exist' do
    rtn_value = User.unenroll_course(@user, '1')
    expect(rtn_value).to eq(GlobalConstants::COURSE_NONEXISTENT)
  end

  it 'user unenrolls from a class that user is not enrolled in' do
    rtn_value = User.unenroll_course(@user, @course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_ALREADY_ENROLLED)
  end

  it 'knows which courses he/she is enrolled in' do
    User.enroll_course(@user, @course.title)
    User.enroll_course(@user, '1')
    rtn_value = User.list_courses(@user)
    expect(rtn_value).to eq(@user.courses)
  end

"""
  it 'joins studygroup that exists and user is not member of it' do
    rtn_value = User.join_studygroup(@user, @studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)
  end

  it 'joins invalid studygroup that user is not member of' do
    rtn_value = User.join_studygroup(@user, 10)
    expect(rtn_value).to eq(GlobalConstants::STUDYGROUP_DOES_NOT_EXIST)
  end

  it 'joins valid studygroup that user is member of' do
    User.join_studygroup(@user, @studygroup.id)
    rtn_value = User.join_studygroup(@user, @studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::USER_ALREADY_IN_STUDYGROUP)
  end

  it 'user leaves valid studygroup that he/she is a member of' do
    User.join_studygroup(@user, @studygroup.id)
    rtn_value = User.leave_studygroup(@user, @studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)
  end

  it 'user leaves valid studygroup that he/she is NOT a member of' do
    rtn_value = User.leave_studygroup(@user, @studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_IN_STUDYGROUP)
  end

  it 'user leaves invalid studygroup' do
    rtn_value = User.leave_studygroup(@user, @studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::STUDYGROUP_DOES_NOT_EXIST)
  end
"""
end