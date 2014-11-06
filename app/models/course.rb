class Course < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :courses_users
  has_many :studygroups

end
