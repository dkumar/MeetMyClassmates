class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course
  has_many :messages

  validates_presence_of :name
  validates_inclusion_of :maximum_size, in: 2..10
  validate :private_invite_members
  validate :location_for_scheduled
  validate :start_time_before_end_time
  validate :start_time_after_eight_pm

  # If Studygroup is private, invited_users must not be empty
  def private_invite_members
    if private and invited_users.count == 0
      errors.add(:private, 'If Studygroup is private, you must invite at least 1 member.')
    end
  end

  def location_for_scheduled
    if unscheduled==false && location==''
      errors.add(:location, 'must be entered in.')
    end
  end

  def start_time_before_end_time
    if unscheduled==false && start_time.to_i > end_time.to_i
      errors.add(:start_time, ' must be before end time.')
    end
  end

  def start_time_after_eight_pm
    if unscheduled==false && start_time.hour < 8
      errors.add(:start_time, ' must be after 8 a.m.')
    end
  end
end

