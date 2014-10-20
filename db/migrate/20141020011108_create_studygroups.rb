class CreateStudygroups < ActiveRecord::Migration
  def change
    create_table :studygroups do |t|
      t.string :name
      t.time :time
      t.date :date
      t.string :location
      t.user :owner
      t.integer :minimum_size
      t.integer :maximum_size
      t.boolean :private
      t.integer :recurring
      t.string :tags
      t.boolean :unscheduled

      t.timestamps
    end
  end
end
