class CreateMentors < ActiveRecord::Migration
  def self.up
    create_table :mentors do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :zipcode
      t.string :home_phone
      t.string :cell_phone
      t.string :email
      t.string :race
      t.integer :age
      t.boolean :time_afternoon
      t.boolean :time_evening
      t.boolean :time_weekends
      t.string :exp_org_1
      t.string :exp_title_1
      t.datetime :exp_start_1
      t.datetime :exp_stop_1
      t.string :exp_org_2
      t.string :exp_title_2
      t.datetime :exp_start_2
      t.datetime :exp_stop_2
      t.string :exp_org_3
      t.string :exp_title_3
      t.datetime :exp_start_3
      t.datetime :exp_stop_3
      t.string :exp_org_4
      t.string :exp_title_4
      t.datetime :exp_start_4
      t.datetime :exp_stop_4
      t.text :worked_with_middle_school
      t.text :two_activities
      t.text :helpful_support
      t.string :seattle_location
      t.string :brothers_sisters
      t.string :have_children
      t.string :have_pets
      t.text :fav_subject
      t.text :hobbies
      t.text :work_exp_mentee
      t.text :new_activities_mentee
      t.text :describe_yourself
      t.text :why_be_a_mentor
      t.text :what_skills_bring_you

      t.timestamps
    end
  end

  def self.down
    drop_table :mentors
  end
end
