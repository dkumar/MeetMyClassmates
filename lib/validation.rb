module Validation

  def self.user_exists(found_user)
    if found_user == nil
      return false
    else
      return true
    end
  end

  def self.course_exists(found_course)
    if found_course == nil
      return false
    else
      return true
    end
  end

  def self.studygroup_exists(found_studygroup)
    if found_studygroup == nil
      return false
    else
      return true
    end
  end

end