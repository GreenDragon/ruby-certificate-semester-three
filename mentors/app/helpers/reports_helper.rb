module ReportsHelper
private
	def create_mentor_excel(mentors)
		#bold = wb.add_format(:bold => 1)
		#date = wb.add_format(:num_format => "yyyy/mm")
		#time = wb.add_format(:num_format => "yyyy/mm/dd hh:mm AM/PM")

    returning String.new do |str|
      # 
      str << "<html><head></head><body><table border='1'>"
      str << "<tr>"
		  str << "<th>Name</th>"
		  str << "<th>Address</th>"
		  str << "<th>City</th>"
		  str << "<th>State</th>"
		  str << "<th>ZIP Code</th>"
		  str << "<th>Home Phone</th>"
		  str << "<th>Cell Phone</th>"
		  str << "<th>E-Mail</th>"
		  str << "<th>Ethnicity</th>"
		  str << "<th>Age</th>"
		  str << "<th>Afternoons?</th>"
		  str << "<th>Evenings?</th>"
		  str << "<th>Weekends?</th>"
		  str << "<th>Org_1</th>"
		  str << "<th>Title_1</th>"
		  str << "<th>Start_1</th>"
		  str << "<th>Stop_1</th>"
		  str << "<th>Org_2</th>"
		  str << "<th>Title_2</th>"
		  str << "<th>Start_2</th>"
		  str << "<th>Stop_2</th>"
		  str << "<th>Org_3</th>"
		  str << "<th>Title_3</th>"
		  str << "<th>Start_3</th>"
		  str << "<th>Stop_3</th>"
		  str << "<th>Org_4</th>"
		  str << "<th>Title_4</th>"
		  str << "<th>Start_4</th>"
		  str << "<th>Stop_4</th>"
		  str << "<th>Middle School Work</th>"
		  str << "<th>Two Activities</th>"
		  str << "<th>Helpful Support</th>"
		  str << "<th>Seattle Location</th>"
		  str << "<th>Brothers/Sisters</th>"
		  str << "<th>Have Children</th>"
		  str << "<th>Have Pets</th>"
		  str << "<th>Fav Subjects</th>"
		  str << "<th>Hobbies Interests</th>"
		  str << "<th>Work Experience</th>"
		  str << "<th>New Activities</th>"
		  str << "<th>Describe Yourself</th>"
		  str << "<th>Why a Mentor</th>"
		  str << "<th>What Skills Bring You</th>"
		  str << "<th>Created On</th>"
      str << "</tr>"

		  # data
		  mentors.each do |m|
        str << "<tr>"
        #
			  str << "<td>#{m.name}</td>"
			  str << "<td>#{m.address}</td>"
			  str << "<td>#{m.city}</td>"
			  str << "<td>#{m.state}</td>"
			  str << "<td>#{m.zipcode}</td>"
			  str << "<td>#{m.home_phone}</td>"
			  str << "<td>#{m.cell_phone}</td>"
			  str << "<td>#{m.email}</td>"
			  str << "<td>#{m.race}</td>"
			  str << "<td>#{m.age}</td>"
			  str << "<td>#{m.time_afternoon.to_s}</td>"
			  str << "<td>#{m.time_evening.to_s}</td>"
			  str << "<td>#{m.time_weekends.to_s}</td>"
			  str << "<td>#{m.exp_org_1}</td>"
			  str << "<td>#{m.exp_title_1}</td>"
			  str << "<td>#{m.exp_start_1.strftime("%Y/%d")}</td>"	if m.exp_start_1
			  str << "<td>#{m.exp_stop_1.strftime("%Y/%d")}</td>"	if m.exp_stop_1
			  str << "<td>#{m.exp_org_2}</td>"
			  str << "<td>#{m.exp_title_2}</td>"
			  str << "<td>#{m.exp_start_1.strftime("%Y/%d")}</td>"	if m.exp_start_2
			  str << "<td>#{m.exp_stop_2.strftime("%Y/%d")}</td>"	if m.exp_stop_2
			  str << "<td>#{m.exp_org_3}</td>"
			  str << "<td>#{m.exp_title_3}</td>"
			  str << "<td>#{m.exp_start_3.strftime("%Y/%d")}</td>"	if m.exp_start_3
			  str << "<td>#{m.exp_stop_3.strftime("%Y/%d")}</td>"	if m.exp_stop_3
			  str << "<td>#{m.exp_org_4}</td>"
			  str << "<td>#{m.exp_title_4}</td>"
			  str << "<td>#{m.exp_start_4.strftime("%Y/%d")}</td>"	if m.exp_start_4
			  str << "<td>#{m.exp_stop_4.strftime("%Y/%d")}</td>"	if m.exp_stop_4
			  str << "<td>#{m.worked_with_middle_school}</td>"
			  str << "<td>#{m.two_activities}</td>"
			  str << "<td>#{m.helpful_support}</td>"
			  str << "<td>#{m.seattle_location}</td>"
			  str << "<td>#{m.brothers_sisters}</td>"
			  str << "<td>#{m.have_children}</td>"
			  str << "<td>#{m.have_pets}</td>"
			  str << "<td>#{m.fav_subject}</td>"
			  str << "<td>#{m.hobbies}</td>"
			  str << "<td>#{m.work_exp_mentee}</td>"
			  str << "<td>#{m.new_activities_mentee}</td>"
			  str << "<td>#{m.describe_yourself}</td>"
			  str << "<td>#{m.why_be_a_mentor}</td>"
			  str << "<td>#{m.what_skills_bring_you}</td>"
			  str << "<td>#{m.created_at.strftime("%Y/%m/%d %H:%M")}</td>"
        #
        str << "</tr>"
		  end
      str << "</table></body></html>"
    end
	end
end
