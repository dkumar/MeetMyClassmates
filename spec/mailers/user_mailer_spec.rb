require "rails_helper"

describe UserMailer do
  before(:each) do
    User.delete_all
    Studygroup.delete_all
    Course.delete_all

    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)
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

  # is the email being sent?
  it 'should send an email' do
    # ActionMailer::Base.deliveries.count.should == 1
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  # is the email being sent to the desired recipient?
  it 'renders the receiver email' do
    # p '*'*10
    # p ActionMailer::Base.deliveries.first.to.first
    # ActionMailer::Base.deliveries.first.to.first.should == @user.email
    expect(ActionMailer::Base.deliveries.first.to.first).to eq(@user.email)
  end

  # does the email have the correct subject line?
  it 'should set the subject to the correct subject' do
    # ActionMailer::Base.deliveries.first.subject.should == 'Invitation to join a studygroup'
    expect(ActionMailer::Base.deliveries.first.subject).to eq('Invitation to join a studygroup')
  end

  # was the email being sent from the correct address?
  it 'renders the sender email' do
    expect(ActionMailer::Base.deliveries.first.from.first).to eq('meetmyclassmate@gmail.com')
  end

end

