class User < ActiveRecord::Base
  has_and_belongs_to_many :studygroups
  has_and_belongs_to_many :courses

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  COURSE_NONEXISTANT = -1

  def self.find_user(email, password)
    return User.find_by(email: email, password: password)
  end

  def self.enroll(email, password, course_name)
    #class is enrollable (controller logic)
    #User is NOT already enrolled in the class (controller logic)
    #find course entry and add user to userlist
    #Course.add_user

    #
    user = self.find_user(email, password)
    course = Course.find_by(name: course_name)

    #error catcher necessary?
    if course == nil
      return COURSE_NONEXISTANT
    else
      course.add_user()
    end
  end


  def self.unenroll(course)
    #assuming user is already enrolled (controller logic)
    #if so, remove user from enrolled list
    #Course.remove_user
  end

end
