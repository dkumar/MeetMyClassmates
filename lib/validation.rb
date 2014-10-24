module Validation

  def user_exists(found_user)
    if found_user == nil
      return false
    else
      return true
    end
  end

  def course_exists(found_course)
    if found_course == nil
      return false
    else
      return true
    end
  end

  def studygroup_exists(found_studygroup)
    if found_studygroup == nil
      return false
    else
      return true
    end
  end

end