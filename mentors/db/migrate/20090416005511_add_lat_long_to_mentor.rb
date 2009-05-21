class AddLatLongToMentor < ActiveRecord::Migration
  def self.up
    add_column :mentors, :lat, :decimal, :precision => 15, :scale => 10
    add_column :mentors, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :mentors, :lng
    remove_column :mentors, :lat
  end
end
