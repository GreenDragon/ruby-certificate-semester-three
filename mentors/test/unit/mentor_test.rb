require 'test_helper'

# Frak! This makes it a speed demon

class Mentor < ActiveRecord::Base
private
  def geocode_address
    true
    self.lat = 47.5999225
    self.lng = -122.2973159
  end
end

class MentorTest < ActiveSupport::TestCase
  # include RR::Adapters::TestUnit
  def setup
    @mentor = Factory.create(:mentor)
    @params = { :address => "2706 S. Jackson St.", :city => "Seattle",
                :state => "WA", :zipcode => "98144" }
  end
  
  context "A User instance" do
    should_validate_presence_of :name, :address, :city, :state, :zipcode,
      :email, :age, :exp_org_1, :exp_title_1, :exp_start_1, :exp_stop_1,
      :worked_with_middle_school, :two_activities, :helpful_support,
      :brothers_sisters, :have_children, :have_pets, :fav_subject,
      :hobbies, :work_exp_mentee, :new_activities_mentee,
      :describe_yourself, :why_be_a_mentor, :what_skills_bring_you

    should_validate_numericality_of :age
    
    should_validate_uniqueness_of   :email
  end

  test "should build geocode string" do
    actual = Mentor.create(@params).address_string
    expected = "2706 S. Jackson St., Seattle, WA, USA, 98144"

    assert_equal expected, actual
  end
end
