class User < ActiveRecord::Base
  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  COURSE_NONEXISTANT = -1
  USER_ALREADY_ENROLLED = -2
  USER_CANNOT_UNENROLL = -3

  def self.course_list(email)
    found_user = User.find_by(email: email)
    if found_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    return found_user.courses()
  end


  def self.enroll(email, course_name)

    found_course = Course.find_by(name: course_name)
    found_user = User.find_by(email: email)
    #check if user exists
    if found_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end
    #check if course is a valid course
    if found_course == nil
      return COURSE_NONEXISTANT
    end
    #check if user is already enrolled in the course
    if found_user.courses.find(found_course) != nil
      return USER_ALREADY_ENROLLED
    end
    found_course.add_user(user)
  end


  def self.unenroll(email, course_name)
    #assuming user is already enrolled (controller logic)
    #if so, remove user from enrolled list
    #Course.remove_user
    found_course = Course.find_by(name: course_name)
    found_user = User.find_by(email: email)

    #check if user exists
    if found_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end
    #check if course is a valid course
    if found_course == nil
      return COURSE_NONEXISTANT
    end
    #validate that user is already enrolled in course
    if found_user.courses.find(found_course) == nil
      return USER_CANNOT_UNENROLL
    end

    found_course.remove_user(found_user)

  end
end
