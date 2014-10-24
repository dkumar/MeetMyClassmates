class CreateStudygroupsUsers < ActiveRecord::Migration
  def change
    create_table :studygroups_users, id: false do |t|
      t.integer :studygroup_id
      t.integer :user_id
    end
  end
end
