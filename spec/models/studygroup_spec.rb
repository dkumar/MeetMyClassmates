require 'rails_helper'

describe Studygroup do
  before :each do
    User.delete_all
    Studygroup.delete_all
    Course.delete_all

    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)
    @owner = FactoryGirl.create(:user)
    @studygroup = FactoryGirl.create(:studygroup)
  end

  it 'is created by a user that is enrolled in associated course' do
    @owner.enroll_course(@course.title)
    rtn_value = Studygroup.create_studygroup(@owner, @studygroup.name, @studygroup.time, @course.title)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
  end

  it 'is created by a user that is not enrolled in associated course' do
    rtn_value = Studygroup.create_studygroup(@owner, @studygroup.name, @studygroup.time, @course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_ALREADY_ENROLLED)
  end

  it 'is created by user who does not exist' do
    user = FactoryGirl.build(:user)
    rtn_value = Studygroup.create_studygroup(user, @studygroup.name, @studygroup.time, @course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_DOES_NOT_EXIST)
  end

  it 'can be deleted by the owner' do
    @owner.enroll_course(@course.title)
    rtn_value = Studygroup.create_studygroup(@owner, @studygroup.name, @studygroup.time, @course.title)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    rtn_value2 = rtn_value.delete_studygroup(@owner)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)
  end

  it 'cannot be deleted by member who is not an owner' do
    @owner.enroll_course(@course.title)
    rtn_value = Studygroup.create_studygroup(@owner, @studygroup.name, @studygroup.time, @course.title)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)

    @user.enroll_course(@course.title)
    rtn_value2 = @user.join_studygroup(rtn_value.id)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)

    rtn_value3 = rtn_value.delete_studygroup(@user)
    expect(rtn_value3).to eq(GlobalConstants::USER_NOT_STUDYGROUP_OWNER)
  end
end