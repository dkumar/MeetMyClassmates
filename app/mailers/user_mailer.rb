class UserMailer < ActionMailer::Base
  # require 'mail'
  default from: "meetmyclassmate@gmail.com"

  # send invitation email to the user
  def invite_email(inviter, user, studygroup)
    @user = user
    @inviter = inviter
    @studygroup = studygroup
    @url = 'http://example.com/studygroup_page'

    mail(to: @user.email, subject: 'Invitation to join a studygroup')

  end
end