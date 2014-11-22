class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.integer :poster
      t.datetime :date_time

      t.timestamps
    end
  end
end
