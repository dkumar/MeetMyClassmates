module Validation

  def self.user_exists(check_user)
    if check_user == nil
      return false
    else
      return true
    end
  end

  def self.user_enrolled_in_course(check_course, check_user)
    if check_course.users.exists?(id: check_user.id)
      return true
    else
      return false
    end
  end

  def self.user_in_studygroup(check_studygroup, check_user)
    if check_studygroup.users.exists?(id: check_user.id)
      return true
    else
      return false
    end
  end

  def self.course_exists(check_course)
    if check_course == nil
      return false
    else
      return true
    end
  end

  def self.studygroup_exists(check_studygroup)
    if check_studygroup == nil
      return false
    else
      return true
    end
  end

  def self.is_owner_of_studygroup(check_user, check_studygroup)
    unless check_studygroup.owner_id == check_user.__id__
      return false
    else
      return true
    end
  end

end