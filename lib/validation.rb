module Validation

  def self.user_exists(user_to_check)
    User.exists?(user_to_check)
  end

  def self.user_enrolled_in_course(check_course, user_to_check)
    check_course.users.exists?(id: user_to_check.id)
  end

  def self.user_in_studygroup(studygroup_to_check, user_to_check)
    studygroup_to_check.users.exists?(id: user_to_check.id)
  end

  def self.course_exists(course_to_check)
    Course.exists?(course_to_check)
  end

  def self.studygroup_exists(studygroup_to_check)
    Studygroup.exists?(studygroup_to_check)
  end

  def self.is_owner_of_studygroup(user_to_check, studygroup_to_check)
    studygroup_to_check.owner_id == user_to_check.id
  end

  def self.user_invited(studygroup_to_check, user_to_check)
    studygroup_to_check.invited_users.include?(user_to_check)
  end
end