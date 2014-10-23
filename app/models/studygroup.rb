class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course

  USER_ALREADY_IN_STUDYGROUP = -5
  STUDYGROUP_DOES_NOT_EXIST = -6

  def self.invite_user(email, studygroup_id)
    #send e-mail invitation to user
    invite_user = User.find_by(email: email)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    if invite_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if user is already invited/added to studygroup
    if found_studygroup.users.find(invite_user) == nil
      return USER_ALREADY_IN_STUDYGROUP
    end

    #check if valid studygroup
    if found_studygroup == nil
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end
    #SEND OUT AN EMAIL TO THAT USER'S E-MAIL ADDRESS
  end



  def self.add_user(email, password, studygroup_id)
    add_user = User.find_by(email: email)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check that user exists
    if add_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    found_studygroup.users << add_user

  end

  def self.remove_user(email, studygroup_id)
    remove_user = User.find_by(email: email)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check if user exists
    if remove_user == nil
      return GlobalConstants::USER_DOES_NOT_EXIST
    end
    #check if study group exists
    if found_studygroup == nil
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end
    #remove user from studygroup
    found_studygroup.users.delete(remove_user)

  end

end

