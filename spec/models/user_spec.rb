require 'rails_helper'
require 'simplecov'

describe User do
  before :each do
    User.delete_all
    Studygroup.delete_all
    Course.delete_all

    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)
    @owner = FactoryGirl.create(:user)

    @studygroup = FactoryGirl.create(:studygroup)
    @studygroup.course = @course
    @studygroup.save

    @recurring_studygroup = FactoryGirl.create(:recurring_studygroup)
    @recurring_studygroup.course = @course
    @recurring_studygroup.save

    @private_studygroup = FactoryGirl.create(:private_studygroup)
    @private_studygroup.course = @course
    @private_studygroup.save

    @private_recurring_studygroup = FactoryGirl.create(:private_recurring_studygroup)
    @private_recurring_studygroup.course = @course
    @private_recurring_studygroup.save

    @unscheduled_studygroup = FactoryGirl.create(:unscheduled_studygroup)
    @unscheduled_studygroup.course = @course
    @unscheduled_studygroup.save

    @private_unscheduled_studygroup = FactoryGirl.create(:private_unscheduled_studygroup)
    @private_unscheduled_studygroup.course = @course
    @private_unscheduled_studygroup.save
  end

  # TESTING ENROLL
  it 'enrolls in a valid class that user is not enrolled in' do
    rtn_value = @user.enroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)
    expect(@course.users.exists?(@user)).to eq(true)
  end

  it 'attempts to enroll in invalid class' do
    rtn_value = @user.enroll_course('1')
    expect(rtn_value).to eq(GlobalConstants::COURSE_NONEXISTENT)
  end

  it 'attempts to enroll in class user is already enrolled in' do
    @user.enroll_course(@course.title)
    rtn_value = @user.enroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_ALREADY_ENROLLED)
  end

  it 'unenrolls from a course they are previously enrolled in' do
    @user.enroll_course(@course.title)
    rtn_value = @user.unenroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)
    expect(@course.users.exists?(@user)).to eq(false)
  end

  it 'unenrolls in a class that doesn\t exist' do
    rtn_value = @user.unenroll_course('1')
    expect(rtn_value).to eq(GlobalConstants::COURSE_NONEXISTENT)
  end

  it 'unenrolls from a class that user is not enrolled in' do
    rtn_value = @user.unenroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_ALREADY_ENROLLED)
  end

  it 'attempts to join a studygroup that exists and that user is not already a member of' do
    rtn_value = @user.enroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)

    rtn_value2 = @user.join_studygroup(@studygroup.id)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)
    expect(@studygroup.users.exists?(@user)).to eq(true)
  end

  it 'attempts to join an invalid studygroup that user is not member of' do
    rtn_value = @user.join_studygroup(10)
    expect(rtn_value).to eq(GlobalConstants::STUDYGROUP_DOES_NOT_EXIST)
  end

  it 'attempts to join a valid studygroup that user is not enrolled in course for' do
    rtn_value = @user.join_studygroup(@studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_ALREADY_ENROLLED)
  end

  it 'attempts to join a valid private studygroup that user is not invited to' do
    rtn_value = @user.join_studygroup(@private_studygroup.id)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_INVITED)
  end

  it 'joins valid studygroup that user is member of' do
    rtn_value = @user.enroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)

    rtn_value2 = @user.join_studygroup(@studygroup.id)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)

    rtn_value3 = @user.join_studygroup(@studygroup.id)
    expect(rtn_value3).to eq(GlobalConstants::USER_ALREADY_IN_STUDYGROUP)
  end

  it 'leaves valid studygroup that he/she is a member of' do
    rtn_value = @user.enroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)

    rtn_value2 = @user.join_studygroup(@studygroup.id)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)

    rtn_value3 = @user.leave_studygroup(@studygroup.id)
    expect(rtn_value3).to eq(GlobalConstants::SUCCESS)
    expect(@studygroup.users.exists?(@user)).to eq(false)
  end

  it 'leaves valid studygroup that he/she is NOT a member of' do
    rtn_value = @user.enroll_course(@course.title)
    expect(rtn_value).to eq(GlobalConstants::SUCCESS)

    rtn_value2 = @user.leave_studygroup(@studygroup.id)
    expect(rtn_value2).to eq(GlobalConstants::USER_NOT_IN_STUDYGROUP)
  end

  it 'leaves invalid studygroup' do
    rtn_value = @user.leave_studygroup(10)
    expect(rtn_value).to eq(GlobalConstants::STUDYGROUP_DOES_NOT_EXIST)
  end

  it 'creates a public, non-recurring studygroup within a course user is enrolled in' do
    @owner.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@studygroup.name, @course.title, start_time: @studygroup.start_time, end_time: @studygroup.end_time,)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a public studygroup within a course user is enrolled in and invites another user' do
    @owner.enroll_course(@course.title)
    @user.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@studygroup.name, @course.title, start_time: @studygroup.start_time,
                                         end_time: @studygroup.end_time,
                                         owner_id: @owner.id, invited_users: [@user])
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a public, recurring studygroup within a course user is enrolled in' do
    @owner.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@recurring_studygroup.name, @course.title, start_time: @recurring_studygroup.start_time,
                                         end_time: @recurring_studygroup.end_time, recurring: @recurring_studygroup.recurring,
                                         recurring_days: @recurring_studygroup.recurring_days,
                                         last_occurrence: @recurring_studygroup.last_occurrence, owner_id: @owner.id)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a public, unscheduled studygroup within a course user is enrolled in' do
    @owner.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@unscheduled_studygroup.name, @course.title, unscheduled: @unscheduled_studygroup, owner_id: @owner.id)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a private studygroup within a course user is enrolled in and invites another user' do
    @owner.enroll_course(@course.title)
    @user.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@private_studygroup.name, @course.title, start_time: @private_studygroup.start_time,
                                         end_time: @private_studygroup.end_time,
                                         owner_id: @owner.id, invited_users: [@user])
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a private, recurring studygroup within a course user is enrolled in and invites another user' do
    @owner.enroll_course(@course.title)
    @user.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@private_recurring_studygroup.name, @course.title, private: @private_recurring_studygroup.private, recurring: @private_recurring_studygroup.recurring,
                                         invited_users: [@user], start_time: @private_recurring_studygroup.start_time, end_time: @private_recurring_studygroup.end_time,
                                         recurring_days: @private_recurring_studygroup.recurring_days,
                                         last_occurrence: @private_recurring_studygroup.last_occurrence, owner_id: @owner.id)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a private, unscheduled studygroup within a course user is enrolled in' do
    @owner.enroll_course(@course.title)
    @user.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@private_unscheduled_studygroup.name, @course.title, private: @private_unscheduled_studygroup.private, invited_users: [@user], owner_id: @owner.id)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)
    expect(Studygroup.exists?(rtn_value)).to eq(true)
  end

  it 'creates a studygroup with a course user is not enrolled in' do
    rtn_value = @owner.create_studygroup(@studygroup.name, @course.title, start_time: @studygroup.start_time, end_time: @studygroup.end_time)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_ALREADY_ENROLLED)
  end

  it 'creates a studygroup with a nonexistent course' do
    rtn_value = @owner.create_studygroup(@studygroup.name, '1', start_time: @studygroup.start_time, end_time: @studygroup.end_time)
    expect(rtn_value).to eq(GlobalConstants::COURSE_NONEXISTENT)
  end

  it 'deletes studygroup user is owner of' do
    @owner.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@studygroup.name, @course.title, start_time: @studygroup.start_time, end_time: @studygroup.end_time)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)

    rtn_value2 = @owner.delete_studygroup(rtn_value)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)
    expect(Studygroup.exists?(rtn_value)).to eq(false)
  end

  it 'cannot delete studygroup user is not owner even if user is a member of' do
    @owner.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@studygroup.name, @course.title, start_time: @studygroup.start_time, end_time: @studygroup.end_time)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)

    @user.enroll_course(@course.title)
    rtn_value2 = @user.join_studygroup(rtn_value.id)
    expect(rtn_value2).to eq(GlobalConstants::SUCCESS)

    rtn_value3 = @user.delete_studygroup(rtn_value)
    expect(rtn_value3).to eq(GlobalConstants::USER_NOT_STUDYGROUP_OWNER)
  end

  it 'cannot delete studygroup user is not owner and is not a member of' do
    @owner.enroll_course(@course.title)
    rtn_value = @owner.create_studygroup(@studygroup.name, @course.title, start_time: @studygroup.start_time, end_time: @studygroup.end_time)
    expect(rtn_value.instance_of?(Studygroup)).to eq(true)

    @user.enroll_course(@course.title)

    rtn_value3 = @user.delete_studygroup(rtn_value)
    expect(rtn_value3).to eq(GlobalConstants::USER_NOT_IN_STUDYGROUP)
  end

end