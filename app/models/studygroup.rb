class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course

  def self.create_studygroup(name, )

  end

  def self.delete_studygroup()

  end

  def self.invite_user(user_to_invite, studygroup_id)
    #send e-mail invitation to user
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check if user exists
    if not Validation.user_exists(user_to_invite)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if studygroup exists
    if not Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    #check if user is already invited/added to studygroup
    if found_studygroup.users.find(user_to_invite) == nil
      return GlobalConstants::USER_ALREADY_IN_STUDYGROUP
    end

    #SEND OUT AN EMAIL TO THAT USER'S E-MAIL ADDRESS
  end


  def self.add_user(user_to_add, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check that user exists
    if not Validation.user_exists(user_to_add)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if studygroup exists
    if not Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    found_studygroup.users << user_to_add
  end


  def self.remove_user(user_to_remove, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check if user exists
    if not Validation.user_exists(user_to_remove)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if study group exists
    if not Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    #remove user from studygroup
    found_studygroup.users.delete(user_to_remove)
  end

end

