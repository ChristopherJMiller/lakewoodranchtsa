class AddTeamAdminToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :admin, :boolean
  end
end
