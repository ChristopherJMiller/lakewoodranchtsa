class AddImagePathToEvents < ActiveRecord::Migration
  def change
    add_column :events, :image_path, :string
  end
end
