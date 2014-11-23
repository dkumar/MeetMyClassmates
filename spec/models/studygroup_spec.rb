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
                                           start_time: Time.now, end_time: Time.now + 3600, location: 'soda',
                                           maximum_size: 10, minimum_size: 2,
                                           private: false, invited_users: [],
                                           owner_id: @user.id, course: @course, recurring: false,
                                           recurring_days: [], last_occurrence: nil)
  end

  it 'validates minimum size' do
    @created_studygroup.minimum_size = 1
    @created_studygroup.save
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.minimum_size = 11
    @created_studygroup.save
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.minimum_size = 8
    @created_studygroup.save
    expect(@created_studygroup.valid?).to eq(true)
    expect(@created_studygroup.minimum_size).to eq(8)
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

  it 'validates if recurring days after pick if it is recurring' do
    @created_studygroup.recurring = true
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.recurring_days = [0, 1]
    expect(@created_studygroup.valid?).to eq(true)
  end

  it 'validates if members are invited if it is private' do
    @created_studygroup.private = true
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.invited_users = [@user.email]
    expect(@created_studygroup.valid?).to eq(true)
  end

  it 'minimum size must be less than max size' do
    @created_studygroup.minimum_size = 9
    @created_studygroup.maximum_size = 3
    expect(@created_studygroup.valid?).to eq(false)

    @created_studygroup.minimum_size = 3
    expect(@created_studygroup.valid?).to eq(true)
  end
end