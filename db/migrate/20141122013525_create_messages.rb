class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :user_id
      t.integer :studygroup_id

      t.timestamps
    end
  end
end
