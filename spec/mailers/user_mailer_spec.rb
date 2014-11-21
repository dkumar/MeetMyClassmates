require "rails_helper"

describe UserMailer do
  before(:each) do
    User.delete_all
    Studygroup.delete_all
    Course.delete_all

    @user = FactoryGirl.create(:user)
    @user.email = 'alice.wang@berkeley.edu'
    @owner = FactoryGirl.create(:owner)

    @studygroup = FactoryGirl.create(:studygroup)
    @studygroup.course = @course
    @studygroup.save

    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    UserMailer.invite_email(@owner, @user, @studygroup).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it 'should send an email' do
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'renders the receiver email' do
    expect(ActionMailer::Base.deliveries.first.to.first).to eq(@user.email)
  end

  it 'should set the subject to the correct subject' do
    expect(ActionMailer::Base.deliveries.first.subject).to eq('Invitation to join a studygroup')
  end

  it 'renders the sender email' do
    expect(ActionMailer::Base.deliveries.first.from.first).to eq('meetmyclassmate@gmail.com')
  end

end

