class Course < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :courses_users
  has_many :studygroups

  #can assume course existence is validated in user model

  def self.add_user(add_user, to_course)
    to_course.users<< add_user
  end

  def self.remove_user(rm_user, from_course)
    from_course.users.delete(rm_user)
  end

  #fix
  def self.add_studygroup(add_studygroup, to_course)
    to_course.studygroups<< add_studygroup
  end

  def self.remove_studygroup(rm_studygroup, from_course)
    from_course.studygroups.delete(rm_studygroup)
  end
end
