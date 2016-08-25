class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :accountabilitylog, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :binderstatus
      t.text :tasks
      t.text :goals

      t.timestamps null: false
    end
  end
end
