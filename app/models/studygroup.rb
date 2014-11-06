class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course

  # creates new studygroup, user is now the owner
  def self.create_studygroup(studygroup_owner, studygroup_name, studygroup_time, studygroup_course_name)
    # TODO: add in other fields necessary for studygroup (e.g. location)
    # TODO: pass in studygroup_params from controller instead of manually adding each field

    studygroup_course = Course.find_by(title: studygroup_course_name)

    unless Validation.user_exists(studygroup_owner)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    unless Validation.course_exists(studygroup_course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    unless Validation.user_enrolled_in_course(studygroup_course, studygroup_owner)
      return GlobalConstants::USER_NOT_ALREADY_ENROLLED
    end

    created_studygroup = Studygroup.create(name: studygroup_name, time: studygroup_time, owner_id: studygroup_owner.id, course: studygroup_course)

    # associate studygroup with course
    studygroup_course.studygroups<< created_studygroup

    # add owner to studygroup users
    created_studygroup.users<< studygroup_owner

    created_studygroup
  end

  # deletes existing studygroup that the user owns
  def delete_studygroup(studygroup_owner)
    unless Validation.is_owner_of_studygroup(studygroup_owner, self)
      return GlobalConstants::USER_NOT_STUDYGROUP_OWNER
    end

    # deleting studygroup from studygroups users join table
    self.users.destroy

    # deleting studygroup from course's has_many table
    studygroup_course = Course.find_by(id: self.course)

    unless Validation.course_exists(studygroup_course)
      return GlobalConstants::COURSE_NONEXISTENT
    end

    studygroup_course.studygroups.delete(self)

    # delete studygroup from database
    self.destroy

    GlobalConstants::SUCCESS
  end

  # invite user to private studygroup
  def invite_user(user_to_invite)
    # TODO: send e-mail invitation to user

    unless Validation.user_exists(user_to_invite)
      return GlobalConstants::USER_DOES_NOT_EXIST
    end

    if found_studygroup.users.find(user_to_invite) == nil
      return GlobalConstants::USER_ALREADY_IN_STUDYGROUP
    end
  end
end

