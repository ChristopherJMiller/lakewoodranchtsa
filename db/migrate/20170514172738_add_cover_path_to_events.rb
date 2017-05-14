class AddCoverPathToEvents < ActiveRecord::Migration
  def change
    add_column :events, :cover_path, :string
  end
end
