class CreateStudygroups < ActiveRecord::Migration
  def change
    create_table :studygroups do |t|
      t.belongs_to :course
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.integer :owner_id
      t.integer :maximum_size, default: 10

      t.date :date

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
