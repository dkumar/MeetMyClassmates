class User < ActiveRecord::Base
  include Validation

  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # ,:confirmable

  def create_studygroup(name, course_title, unscheduled=false, start_time=nil, end_time=nil, date=nil,
               location=nil, maximum_size=-1, minimum_size=-1,
               private=false, recurring=false, recurring_days=nil,
               invited_users=nil, tags=nil,  last_occurrence=nil)
    
    course = Course.find_by(title: course_title)

    unless Validation.course_exists(course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    unless Validation.user_enrolled_in_course(course, self)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    # TODO: invited_users and tags do not currently work via input with an array.

    # create studygroup with all form entries filled out
    created_studygroup = Studygroup.create(name: name, unscheduled: unscheduled, date: date,
                                           start_time: start_time, end_time: end_time, location: location,
                                           maximum_size: maximum_size, minimum_size: minimum_size,
                                           private: private, invited_users: invited_users, tags: tags,
                                           owner_id: self.id, course: course, recurring: recurring,
                                           recurring_days: recurring_days, last_occurrence: last_occurrence)

    # associate studygroup with course
    course.studygroups<< created_studygroup

    # add owner to studygroup users
    created_studygroup.users<< self

    self.invite_users(invited_users, created_studygroup)

    created_studygroup
  end

  # deletes existing studygroup that the user owns
  def delete_studygroup(studygroup_to_delete)

    unless Validation.user_in_studygroup(studygroup_to_delete, self)
      return GlobalConstants::USER_NOT_IN_STUDYGROUP
    end

    unless Validation.is_owner_of_studygroup(self, studygroup_to_delete)
      return GlobalConstants::USER_NOT_STUDYGROUP_OWNER
    end

    unless Validation.studygroup_exists(studygroup_to_delete)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    # deleting studygroup from studygroups_users join table
    studygroup_to_delete.users.destroy

    # deleting studygroup from course's has_many table
    studygroup_course = studygroup_to_delete.course
    studygroup_course.studygroups.delete(studygroup_to_delete)

    # delete studygroup from database
    studygroup_to_delete.destroy

    GlobalConstants::SUCCESS
  end

  # invite user to private studygroup
  def invite_users(users_emails_to_invite, studygroup)
    # TODO: send e-mail invitation to user
    # TODO: How do we do error messages in a for loop?
    # TODO: ERROR HANDLING

    return_codes = GlobalConstants::SUCCESS

    if users_emails_to_invite == nil
        return GlobalConstants::SUCCESS
    end

    for email in users_emails_to_invite.each do
      user_to_invite = User.find_by(email: email)
      code = GlobalConstants::SUCCESS

      unless Validation.user_exists(user_to_invite)
        code = GlobalConstants::USER_DOES_NOT_EXIST
      end

      unless Validation.user_enrolled_in_course(studygroup.course, user_to_invite)
        code = GlobalConstants::USER_NOT_ALREADY_ENROLLED
      end

      unless Validation.user_in_studygroup(studygroup, user_to_invite)
        code = GlobalConstants::USER_ALREADY_IN_STUDYGROUP
      end
      return_codes<< code
      mail = UserMailer.invite_email(self, user_to_invite, studygroup)
      mail.deliver
    end
    return_codes
  end

  def enroll_course(course_title)
    course = Course.find_by(title: course_title)

    unless Validation.course_exists(course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    if Validation.user_enrolled_in_course(course, self)
      return GlobalConstants::USER_ALREADY_ENROLLED
    end

    course.users<< self

    GlobalConstants::SUCCESS
  end

  def unenroll_course(course_title)
    found_course = Course.find_by(title: course_title)

    unless Validation.course_exists(found_course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    unless Validation.user_enrolled_in_course(found_course, self)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    found_course.users.delete(self)

    GlobalConstants::SUCCESS
  end

  def join_studygroup(studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    unless Validation.user_enrolled_in_course(found_studygroup.course, self)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    if Validation.user_in_studygroup(found_studygroup, self)
      return GlobalConstants::USER_ALREADY_IN_STUDYGROUP
    end

    found_studygroup.users<< self

    GlobalConstants::SUCCESS
  end

  def leave_studygroup(studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    unless Validation.user_enrolled_in_course(found_studygroup.course, self)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    unless Validation.user_in_studygroup(found_studygroup, self)
      return GlobalConstants::USER_NOT_IN_STUDYGROUP
    end

    found_studygroup.users.delete(self)

    GlobalConstants::SUCCESS
  end

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?      self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

    # new function to set the password without knowing the current password used in our confirmation controller. 
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  def password_required?
  # Password is required if it is being set, but not for new records
  if !persisted? 
    false
  else
    !password.nil? || !password_confirmation.nil?
  end
end
end
