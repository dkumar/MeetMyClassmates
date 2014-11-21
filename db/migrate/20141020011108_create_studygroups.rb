class CreateStudygroups < ActiveRecord::Migration
  def change
    create_table :studygroups do |t|
      t.belongs_to :course
      t.string :name
      t.time :start_time
      t.time :end_time
      t.string :location
      t.integer :owner_id
      t.integer :minimum_size, default: 2
      t.integer :maximum_size, default: 6

      t.boolean :private, default: false
      t.string :invited_users, array: true, default: []

      t.boolean :recurring, default: false

      t.integer :recurring_days, array: true, default: []
      t.date :last_occurrence

      t.boolean :unscheduled, default: false

      t.timestamps
    end
  end
end
