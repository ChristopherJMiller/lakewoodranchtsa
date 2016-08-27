class CreateAccountabilityLogs < ActiveRecord::Migration
  def change
    create_table :accountability_logs do |t|
      t.date :dueby
      t.date :closingdate

      t.timestamps null: false
    end
  end
end
