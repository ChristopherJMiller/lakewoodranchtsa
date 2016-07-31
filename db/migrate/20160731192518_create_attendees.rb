class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.references :user, index: true, foreign_key: true
      t.references :sign_up_sheet, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
