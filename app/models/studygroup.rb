class Studygroup < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :studygroups_users
  belongs_to :course

  validates_presence_of :name, :location
  validate :private_invite_members
  validate :minimum_size, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validate :maximum_size, numericality: { only_integer: true, less_than_or_equal_to: 10 }
  validate :recurring_must_have_day_selected

  # If Studygroup is private, invited_users must not be empty
  def private_invite_members
    if private and invited_users.count == 0
      errors.add(:private, 'If Studygroup is private, you must invite at least 1 member.')
    end
  end

  def recurring_must_have_day_selected
    if recurring and recurring_days.count == 0
      errors.add(:recurring, 'Must select at least 1 day if Studygroup is a recurring event.')
    end
  end
end

