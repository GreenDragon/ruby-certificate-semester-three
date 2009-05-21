class AddStateToMentor < ActiveRecord::Migration
  def self.up
    add_column :mentors, :state, :string
  end

  def self.down
    remove_column :mentors, :state
  end
end
