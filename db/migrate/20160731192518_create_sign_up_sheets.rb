class CreateSignUpSheets < ActiveRecord::Migration
  def change
    create_table :sign_up_sheets do |t|
      t.string :name
      t.date :date

      t.timestamps null: false
    end
  end
end
