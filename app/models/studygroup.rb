class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :course

  def self.invite_user(user)
    #send e-mail invitation to user
  end

  def self.add_user(user)
  end

  def self.remove_user(user)
  end

end

