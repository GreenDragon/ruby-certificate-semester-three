module ReportsHelper
private
	def create_mentor_excel(mentors)
		#bold = wb.add_format(:bold => 1)
		#date = wb.add_format(:num_format => "yyyy/mm")
		#time = wb.add_format(:num_format => "yyyy/mm/dd hh:mm AM/PM")

    returning String.new do |str|
      # 
      str << "<html>\n<head></head>\n<body>\n<table border='1'>\n"
      str << "<tr>\n"
		  str << "<th>Name</th>\n"
		  str << "<th>Address</th>\n"
		  str << "<th>City</th>\n"
		  str << "<th>State</th>\n"
		  str << "<th>ZIP Code</th>\n"
		  str << "<th>Home Phone</th>\n"
		  str << "<th>Cell Phone</th>\n"
		  str << "<th>E-Mail</th>\n"
		  str << "<th>Ethnicity</th>\n"
		  str << "<th>Age</th>\n"
		  str << "<th>Afternoons?</th>\n"
		  str << "<th>Evenings?</th>\n"
		  str << "<th>Weekends?</th>\n"
		  str << "<th>Org_1</th>\n"
		  str << "<th>Title_1</th>\n"
		  str << "<th>Start_1</th>\n"
		  str << "<th>Stop_1</th>\n"
		  str << "<th>Org_2</th>\n"
		  str << "<th>Title_2</th>\n"
		  str << "<th>Start_2</th>\n"
		  str << "<th>Stop_2</th>\n"
		  str << "<th>Org_3</th>\n"
		  str << "<th>Title_3</th>\n"
		  str << "<th>Start_3</th>\n"
		  str << "<th>Stop_3</th>\n"
		  str << "<th>Org_4</th>\n"
		  str << "<th>Title_4</th>\n"
		  str << "<th>Start_4</th>\n"
		  str << "<th>Stop_4</th>\n"
		  str << "<th>Middle School Work</th>\n"
		  str << "<th>Two Activities</th>\n"
		  str << "<th>Helpful Support</th>\n"
		  str << "<th>Seattle Location</th>\n"
		  str << "<th>Brothers/Sisters</th>\n"
		  str << "<th>Have Children</th>\n"
		  str << "<th>Have Pets</th>\n"
		  str << "<th>Fav Subjects</th>\n"
		  str << "<th>Hobbies Interests</th>\n"
		  str << "<th>Work Experience</th>\n"
		  str << "<th>New Activities</th>\n"
		  str << "<th>Describe Yourself</th>\n"
		  str << "<th>Why a Mentor</th>\n"
		  str << "<th>What Skills Bring You</th>\n"
		  str << "<th>Created On</th>\n"
      str << "</tr>\n"

		  # data
		  mentors.each do |m|
        str << "<tr>\n"
        #
			  str << "<td>#{m.name}</td>\n"
			  str << "<td>#{m.address}</td>\n"
			  str << "<td>#{m.city}</td>\n"
			  str << "<td>#{m.state}</td>\n"
			  str << "<td>#{m.zipcode}</td>\n"
			  str << "<td>#{m.home_phone}</td>\n"
			  str << "<td>#{m.cell_phone}</td>\n"
			  str << "<td>#{m.email}</td>\n"
			  str << "<td>#{m.race}</td>\n"
			  str << "<td>#{m.age}</td>\n"
			  str << "<td>#{m.time_afternoon.to_s}</td>\n"
			  str << "<td>#{m.time_evening.to_s}</td>\n"
			  str << "<td>#{m.time_weekends.to_s}</td>\n"
			  str << "<td>#{m.exp_org_1}</td>\n"
			  str << "<td>#{m.exp_title_1}</td>\n"
			  str << "<td>#{m.exp_start_1.strftime("%Y/%d")}</td>\n"	if m.exp_start_1
        str << "<td>&nbsp;</td>\n" unless m.exp_start_1
			  str << "<td>#{m.exp_stop_1.strftime("%Y/%d")}</td>\n"	if m.exp_stop_1
        str << "<td>&nbsp;</td>\n" unless m.exp_stop_1
			  str << "<td>#{m.exp_org_2}</td>\n"
			  str << "<td>#{m.exp_title_2}</td>\n"
			  str << "<td>#{m.exp_start_1.strftime("%Y/%d")}</td>\n"	if m.exp_start_2
        str << "<td>&nbsp;</td>\n" unless m.exp_start_2
			  str << "<td>#{m.exp_stop_2.strftime("%Y/%d")}</td>\n"	if m.exp_stop_2
        str << "<td>&nbsp;</td>\n" unless m.exp_stop_2
			  str << "<td>#{m.exp_org_3}</td>\n"
			  str << "<td>#{m.exp_title_3}</td>\n"
			  str << "<td>#{m.exp_start_3.strftime("%Y/%d")}</td>\n"	if m.exp_start_3
        str << "<td>&nbsp;</td>\n" unless m.exp_start_3
			  str << "<td>#{m.exp_stop_3.strftime("%Y/%d")}</td>\n"	if m.exp_stop_3
        str << "<td>&nbsp;</td>\n" unless m.exp_stop_3
			  str << "<td>#{m.exp_org_4}</td>\n"
			  str << "<td>#{m.exp_title_4}</td>\n"
			  str << "<td>#{m.exp_start_4.strftime("%Y/%d")}</td>\n"	if m.exp_start_4
        str << "<td>&nbsp;</td>\n" unless m.exp_start_4
			  str << "<td>#{m.exp_stop_4.strftime("%Y/%d")}</td>\n"	if m.exp_stop_4
        str << "<td>&nbsp;</td>\n" unless m.exp_stop_4
			  str << "<td>#{m.worked_with_middle_school}</td>\n"
			  str << "<td>#{m.two_activities}</td>\n"
			  str << "<td>#{m.helpful_support}</td>\n"
			  str << "<td>#{m.seattle_location}</td>\n"
			  str << "<td>#{m.brothers_sisters}</td>\n"
			  str << "<td>#{m.have_children}</td>\n"
			  str << "<td>#{m.have_pets}</td>\n"
			  str << "<td>#{m.fav_subject}</td>\n"
			  str << "<td>#{m.hobbies}</td>\n"
			  str << "<td>#{m.work_exp_mentee}</td>\n"
			  str << "<td>#{m.new_activities_mentee}</td>\n"
			  str << "<td>#{m.describe_yourself}</td>\n"
			  str << "<td>#{m.why_be_a_mentor}</td>\n"
			  str << "<td>#{m.what_skills_bring_you}</td>\n"
			  str << "<td>#{m.created_at.strftime("%Y/%m/%d %H:%M")}</td>\n"
        #
        str << "</tr>\n"
		  end
      str << "</table>\n</body>\n</html>"
    end
	end
end
