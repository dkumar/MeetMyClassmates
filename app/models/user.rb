class User < ActiveRecord::Base
  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #return an array of courses associated with user
  def self.course_list(email)
    found_user = User.find_by(email: email)

    #check if user exists
    if found_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    return found_user.courses()
  end

  #enroll user in course
  def self.enroll(email, course_name)
    found_course = Course.find_by(name: course_name)
    enroll_user = User.find_by(email: email)

    #check if user exists
    if enroll_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if course is a valid course
    if found_course == nil
      return GlobalConstants::COURSE_NONEXISTANT
    end

    #check if user is already enrolled in the course
    if enroll_user.courses.find(found_course) != nil
      return GlobalConstants::USER_ALREADY_ENROLLED
    end

    found_course.add_user(enroll_user, found_course)
  end


  #remove user from course s/he is already enrolled in
  def self.unenroll(email, course_name)
    found_course = Course.find_by(title: course_name)
    unenroll_user = User.find_by(email: email)

    #check if user exists
    if unenroll_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if course is a valid course
    if found_course == nil
      return GlobalConstants::COURSE_NONEXISTANT
    end

    #validate that user is already enrolled in course
    if unenroll_user.courses.find(found_course) == nil
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    found_course.remove_user(unenroll_user, found_course)
  end

end
