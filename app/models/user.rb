class User < ActiveRecord::Base
  include Validation

  has_and_belongs_to_many :studygroups, join_table: :studygroups_users
  has_and_belongs_to_many :courses, join_table: :courses_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def enroll_course(course_name)
    course = Course.find_by(title: course_name)

    unless Validation.course_exists(course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    if Validation.user_enrolled_in_course(course, self)
      return GlobalConstants::USER_ALREADY_ENROLLED
    end

    course.add_user(self)

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

    found_course.remove_user(self)

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

    found_studygroup.add_user(self)

    GlobalConstants::SUCCESS
  end

  def leave_studygroup(studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    unless Validation.user_in_studygroup(found_studygroup, self)
      return GlobalConstants::USER_NOT_IN_STUDYGROUP
    end

    found_studygroup.remove_user(self)

    GlobalConstants::SUCCESS
  end

end
