class User < ActiveRecord::Base
  include Validation

  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable

  #return an array of courses associated with user
  def self.list_courses(user_to_list)
    #check if user exists
    unless Validation.user_exists(user_to_list)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    return user_to_list.courses
  end

  # enroll user in course
  def self.enroll_course(user_to_enroll, course_name)
    found_course = Course.find_by(title: course_name)

    # check if user exists
    unless Validation.user_exists(user_to_enroll)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    # check if course is a valid course
    unless Validation.course_exists(found_course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    # check if user is already enrolled in the course
    if Validation.user_enrolled_in_course(found_course, user_to_enroll)
      return GlobalConstants::USER_ALREADY_ENROLLED
    end

    Course.add_user(user_to_enroll, found_course)

    GlobalConstants::SUCCESS
  end

  # remove user from course s/he is already enrolled in
  def self.unenroll_course(user_to_unenroll, course_name)
    found_course = Course.find_by(title: course_name)

    # check if user exists
    unless Validation.user_exists(user_to_unenroll)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    # check if course is a valid course
    unless Validation.course_exists(found_course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    # validate that user is already enrolled in course
    unless Validation.user_enrolled_in_course(found_course, user_to_unenroll)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    Course.remove_user(user_to_unenroll, found_course)

    GlobalConstants::SUCCESS
  end

  # add user to studygroup
  def self.join_studygroup(user_to_join, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    # check if user exists
    unless Validation.user_exists(user_to_join)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    # check if studygroup exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    if user_to_join.courses.exists(id: found_studygroup.course.id)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    if Validation.user_in_studygroup(found_studygroup, user_to_join)
      return GlobalConstants::USER_ALREADY_IN_STUDYGROUP
    end

    Studygroup.add_user(user_to_join, found_studygroup.id)

    GlobalConstants::SUCCESS
  end

  # remove user from studygroup
  def self.leave_studygroup(user_to_leave, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    # check if user exists
    unless Validation.user_exists(user_to_leave)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    # check if studygroup exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    unless Validation.user_in_studygroup(found_studygroup, user_to_leave)
      return GlobalConstants::USER_NOT_IN_STUDYGROUP
    end

    Studygroup.remove_user(user_to_leave, found_studygroup.id)

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
