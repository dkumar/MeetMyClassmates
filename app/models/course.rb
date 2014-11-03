class Course < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :courses_users
  has_many :studygroups

  #can assume course existence is validated in user model

  def add_user(user_to_add)
    self.users<< user_to_add
  end

  def remove_user(user_to_remove)
    self.users.delete(user_to_remove)
  end

  # fix
  def add_studygroup(studygroup_to_add)
    self.studygroups<< studygroup_to_add
  end

  def remove_studygroup(studygroup_to_remove)
    self.studygroups.delete(studygroup_to_remove)
  end
end
