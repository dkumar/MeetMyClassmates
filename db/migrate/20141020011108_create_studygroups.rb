class CreateStudygroups < ActiveRecord::Migration
  def change
    create_table :studygroups do |t|
      t.belongs_to :course
      t.string :name
      t.time :start_time
      t.time :end_time
      t.date :date
      t.string :location
      t.integer :owner_id
      t.integer :minimum_size
      t.integer :maximum_size

      t.boolean :private
      t.string :invited_users, array: true, default: []

      t.boolean :recurring
      t.integer :recurring_days, array: true, default: []
      t.date :last_occurrence

      t.string :tags, array: true, default: []

      t.boolean :unscheduled

      t.timestamps
    end
  end
end
