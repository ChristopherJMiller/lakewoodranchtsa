class CreateAccountabilitylogs < ActiveRecord::Migration
  def change
    create_table :accountabilitylogs do |t|
      t.date :dueby
      t.date :closingdate

      t.timestamps null: false
    end
  end
end
