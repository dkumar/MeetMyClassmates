class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course

  # creates new studygroup, user is now the owner
  def self.create_studygroup(studygroup_owner, studygroup_name, studygroup_time, studygroup_course_name)
    studygroup_course = Course.find_by(title: studygroup_course_name)

    # check if user exists
    unless Validation.user_exists(studygroup_owner)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end
    # check if course exists
    unless Validation.course_exists(studygroup_course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    # check if user is enrolled in the course
    unless Validation.user_enrolled_in_course(studygroup_course, studygroup_owner)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    # create and save new studygroup
    created_studygroup = Studygroup.create(name: studygroup_name, time: studygroup_time, owner_id: studygroup_owner.__id__, course: studygroup_course)
    # add studygroup to course
    studygroup_course.add_studygroup(created_studygroup)
    # add owner to studygroup users
    created_studygroup.add_user(studygroup_owner)

    # need to add a lot more :()
  end

  # deletes existing studygroup that the user owns
  def self.delete_studygroup(studygroup_to_delete, studygroup_owner)
    # check if studygroup exists
    unless Validation.studygroup_exists(studygroup_to_delete)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end
    # validate that the owner of studygroup is deleting the studygroup
    unless Validation.is_owner_of_studygroup(studygroup_owner, studygroup_to_delete)
      return GlobalConstants::USER_NOT_STUDYGROUP_OWNER
    end
    # does deleting a studygroup record remove the relationship in the join table?
    #If not: follow steps 1 - 3. If so: Only carry out step 3.
    # 1. destroy all associations to studygroup in studygroups_users join table
    Studygroups.Users.destroy(studygroup_to_delete)
    # 2. destroy belongs_to relationship with studygroup and the course it belongs to
    studygroup_course = Course.find_by(id: studygroup_to_delete.course)
    studygroup_course.remove_studygroup(studygroup_to_delete)
    # 3. then destroy studygroup record in database
    studygroup_to_delete.destroy

  end

  # invite user to private studygroup
  def self.invite_user(user_to_invite, studygroup_id)
    #send e-mail invitation to user
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check if user exists
    unless Validation.user_exists(user_to_invite)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if studygroup exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    #check if user is already invited/added to studygroup
    if found_studygroup.users.find(user_to_invite) == nil
      return GlobalConstants::USER_ALREADY_IN_STUDYGROUP
    end

    #SEND OUT AN EMAIL TO THAT USER'S E-MAIL ADDRESS
  end

  # add user to existing studygroup
  def self.add_user(user_to_add, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check that user exists
    unless Validation.user_exists(user_to_add)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if studygroup exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    found_studygroup.users << user_to_add
  end

  # remove user from existing studygroup
  def self.remove_user(user_to_remove, studygroup_id)
    found_studygroup = Studygroup.find_by(id: studygroup_id)

    #check if user exists
    unless Validation.user_exists(user_to_remove)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    #check if study group exists
    unless Validation.studygroup_exists(found_studygroup)
      return GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
    end

    #remove user from studygroup
    found_studygroup.users.delete(user_to_remove)
  end

end

