require 'rails_helper'
require 'simplecov'

describe Studygroup do
  before :each do
    User.delete_all
    Studygroup.delete_all
    Course.delete_all

    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)

    @created_studygroup = Studygroup.create(name: 'name', unscheduled: false,
                                           start_time: Time.utc(2000,"jan",1,12,0,0), end_time: Time.utc(2000,"jan",1,12,0,0) + 3600, location: 'soda',
                                           maximum_size: 10,
                                           private: false, invited_users: [],
                                           owner_id: @user.id, course: @course, recurring: false,
                                           recurring_days: [], last_occurrence: nil)
  end

  it 'validates maximum size' do
    @created_studygroup.maximum_size = 1
    @created_studygroup.save
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.maximum_size = 11
    @created_studygroup.save
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.maximum_size = 8
    @created_studygroup.save
    expect(@created_studygroup.valid?).to eq(true)
    expect(@created_studygroup.maximum_size).to eq(8)
  end

  it 'validates if members are invited if it is private' do
    @created_studygroup.private = true
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.invited_users = [@user.email]
    expect(@created_studygroup.valid?).to eq(true)
  end

end