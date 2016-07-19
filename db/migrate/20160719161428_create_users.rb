class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :rank
      t.string :password_digest
      t.string :verify_token
      t.boolean :verified

      t.timestamps null: false
    end
  end
end
