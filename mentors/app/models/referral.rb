class Referral < ActiveRecord::Base
  validates_presence_of :reference_for, :name, :address, :city, :state
  validates_presence_of :zipcode, :day_phone, :email
  validates_presence_of :what_capacity, :working_with_children, :any_concerns

  # validates_numericality_of
end
