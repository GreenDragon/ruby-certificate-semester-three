class AddReadReportsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :read_reports, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :read_reports
  end
end
