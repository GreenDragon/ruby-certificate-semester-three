require 'test_helper'

class ReferralTest < ActiveSupport::TestCase
  def setup
    @referral = Referral.find(:first)
  end
  
  should_validate_presence_of :reference_for, :name, :address, :city,
    :state, :zipcode, :day_phone, :email, :what_capacity,
    :working_with_children, :any_concerns
end
