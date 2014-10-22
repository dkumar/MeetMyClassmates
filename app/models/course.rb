class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :studygroups

  def self.add_user(user_email)
  end

  def self.remove_user(user_email)
  end

  def self.add_studygroup(studygroup)
  end

  def self.remove_studygroup(studygroup)
  end
end
