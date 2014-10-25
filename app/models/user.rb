class User < ActiveRecord::Base
  include Validation

  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

end
