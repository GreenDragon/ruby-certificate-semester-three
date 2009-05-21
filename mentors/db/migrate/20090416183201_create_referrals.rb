class CreateReferrals < ActiveRecord::Migration
  def self.up
    create_table :referrals do |t|
      t.string :reference_for
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :day_phone
      t.string :evening_phone
      t.string :cell_phone
      t.string :email
      t.integer :known_months
      t.integer :known_years
      t.text :what_capacity
      t.text :working_with_children
      t.text :any_concerns
      t.integer :role_model
      t.integer :reliability
      t.integer :creativity
      t.integer :enthusiasm
      t.integer :cultural_awareness
      t.integer :patience
      t.text :additional_comments

      t.timestamps
    end
  end

  def self.down
    drop_table :referrals
  end
end
