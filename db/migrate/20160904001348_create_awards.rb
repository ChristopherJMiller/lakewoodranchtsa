class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.integer :value
      t.boolean :verified

      t.timestamps null: false
    end
  end
end
