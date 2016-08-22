class AddClosedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :closed, :boolean
  end
end
