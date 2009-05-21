class Mentor < ActiveRecord::Base
	validates_presence_of	:name, :address, :city, :state, :zipcode
  validates_format_of   :name, :with => /\w\s*\w/i, :message => "full name requires at least a first and last name"
	validates_presence_of	:email, :age
	validates_presence_of	:exp_org_1, :exp_title_1
	validates_presence_of	:exp_start_1, :exp_stop_1
	validates_presence_of	:worked_with_middle_school, :two_activities
	validates_presence_of	:helpful_support, :brothers_sisters
	validates_presence_of	:have_children, :have_pets, :fav_subject
	validates_presence_of	:hobbies, :work_exp_mentee, :new_activities_mentee
	validates_presence_of	:describe_yourself, :why_be_a_mentor
	validates_presence_of	:what_skills_bring_you

	validates_numericality_of	:age

	def address_string
		"#{self.address}, #{self.city}, #{self.state}, USA, #{self.zipcode}"
	end

	acts_as_mappable	:auto_geocode => {
							:field => :address_string,
							:error_message => 'Could not geocode address'
						}
	
	before_validation	:geocode_address

private
	def geocode_address
		geo=GeoKit::Geocoders::MultiGeocoder.geocode(address_string)
		errors.add(:address_string, "Could not Geocode address") if !geo.success
		self.lat, self.lng = geo.lat,geo.lng   					 if geo.success
	end
end
