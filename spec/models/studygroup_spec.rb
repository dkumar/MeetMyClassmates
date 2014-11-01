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

  it 'user creates studygroup within course that he/she is NOT enrolled in' do
    rtn_value = @studygroup.create_studygroup(@owner, @studygroup.name, @studygroup.time, @course.title)
    expect(rtn_value).to eq(GlobalConstants::USER_NOT_ALREADY_ENROLLED)
  end
end