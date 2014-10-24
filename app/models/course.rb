class Course < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :courses_users
  has_many :studygroups

  #can assume course existence is validated in user model

  def add_user(user_to_add, to_course)
    to_course.users<< user_to_add
  end

  def remove_user(user_to_remove, from_course)
    from_course.users.delete(user_to_remove)
  end

  # fix
  def add_studygroup(studygroup_to_add, to_course)
    to_course.studygroups<< studygroup_to_add
  end

  def remove_studygroup(studygroup_to_remove, from_course)
    from_course.studygroups.delete(studygroup_to_remove)
  end
end
