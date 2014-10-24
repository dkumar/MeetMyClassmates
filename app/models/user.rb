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
    return user_to_list.courses()
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
    if user_to_enroll.courses.exists?(found_course)
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
    if user_to_unenroll.courses.find(found_course) == nil
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    found_course.remove_user(user_to_unenroll, found_course)
  end


  def join_studygroup

  end


  def leave_studygroup

  end


end
