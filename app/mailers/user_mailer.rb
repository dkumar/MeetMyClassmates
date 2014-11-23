class UserMailer < ActionMailer::Base
  default from: "meetmyclassmate@gmail.com"

  # send invitation email to the user
  def invite_email(owner, inviter_email, studygroup)
    @inviter = inviter_email
    @studygroup = studygroup
    @url = root_url + 'studygroups/' + @studygroup.id.to_s
    mail(to: inviter_email, subject: 'Invitation to join a studygroup')
  end
end