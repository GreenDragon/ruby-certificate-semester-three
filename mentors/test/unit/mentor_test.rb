require 'test_helper'

class MentorTest < ActiveSupport::TestCase
  def setup
    @mentor = Mentor.find(:first)
    @params = { :address => "123 Some St.", :city => "Seattle",
               :state => "WA", :zipcode => "98144" }
  end

  should_validate_presence_of :name, :address, :city, :state, :zipcode,
    :email, :age, :exp_org_1, :exp_title_1, :exp_start_1, :exp_stop_1,
    :worked_with_middle_school, :two_activities, :helpful_support,
    :brothers_sisters, :have_children, :have_pets, :fav_subject,
    :hobbies, :work_exp_mentee, :new_activities_mentee,
    :describe_yourself, :why_be_a_mentor, :what_skills_bring_you

  should_validate_numericality_of :age

  test "should build geocode string" do
    actual = Mentor.create(@params).address_string
    expected = "123 Some St., Seattle, WA, USA, 98144"

    assert_equal expected, actual
  end
end
