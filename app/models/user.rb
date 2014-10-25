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

    puts "in User.enroll"
    puts "found_course: " + found_course.title
    puts "enroll_user: " + user_to_enroll.email

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

    puts "validated, adding user"
    found_course.add_user(user_to_enroll, found_course)
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
    p 'remove from course' 
    found_course.remove_user(user_to_unenroll, found_course)
  end

  # add user to studygroup
  def join_studygroup(user_to_join, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)
    # check if user exists
    unless Validation.user_exists(user_to_unenroll)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end
    # check if studygroup exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    found_studygroup.add_user(user_to_join)
  end

  # remove user from studygroup
  def leave_studygroup(user_to_leave, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)
    # check if user exists
    unless Validation.user_exists(user_to_leave)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end
    # check if studygroup exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end
    found_studygroup.remove_user(user_to_leave)
  end

end
