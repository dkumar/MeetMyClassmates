class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course
  has_many :messages

  validates_presence_of :name, :location
  validates_inclusion_of :maximum_size, in: 2..10
  validate :private_invite_members
  validate :start_time_before_end_time
  validate :start_time_after_eight_pm
  validate :end_time_is_after_current_time

  # If Studygroup is private, invited_users must not be empty
  def private_invite_members
    if private and invited_users.count == 0
      errors.add(:private, 'If Studygroup is private, you must invite at least 1 member that is not yourself.')
    end
  end

  def start_time_before_end_time
    unless unscheduled
      if start_time.to_i >= end_time.to_i
        errors.add(:start_time, 'must be before end time.')
      end
    end
  end

  def start_time_after_eight_pm
    unless unscheduled
      if start_time.hour < 8
        errors.add(:start_time, 'must be after 8 a.m.')
      end
    end
  end

  def end_time_is_after_current_time
    unless unscheduled
      if end_time < Time.new.utc
        errors.add(:end_time, 'must be after the current time.')
      end
    end
  end
end

