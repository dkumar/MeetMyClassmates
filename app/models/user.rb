class User < ActiveRecord::Base
  include Validation

  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable

  def enroll_course(course_name)
    course = Course.find_by(title: course_name)

    unless Validation.course_exists(course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    if Validation.user_enrolled_in_course(course, self)
      return GlobalConstants::USER_ALREADY_ENROLLED
    end

    course.users<< self

    GlobalConstants::SUCCESS
  end

  def unenroll_course(course_name)
    found_course = Course.find_by(title: course_name)

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

    unless Validation.course_exists(found_studygroup.course)
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
