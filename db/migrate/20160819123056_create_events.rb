class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :max_members_per_team

      t.timestamps null: false
    end
  end
end
