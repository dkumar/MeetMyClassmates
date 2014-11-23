class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course
  has_many :messages

  validates_presence_of :name, :location
  validates_inclusion_of :minimum_size, in: 2..10
  validates_inclusion_of :maximum_size, in: 2..10
  validate :private_invite_members
  validate :max_size_greater_than_min
  validate :start_time_before_end_time

  # If Studygroup is private, invited_users must not be empty
  def private_invite_members
    if private and invited_users.count == 0
      errors.add(:private, 'If Studygroup is private, you must invite at least 1 member.')
    end
  end

  def max_size_greater_than_min
    if maximum_size < minimum_size
      errors.add(:minimum_size, 'Minimum size must be less than maximum size.')
    end
  end

  def start_time_before_end_time
    if start_time.to_i > end_time.to_i
      errors.add(:start_time, 'Start time must be before end time.')
    end
  end
end

