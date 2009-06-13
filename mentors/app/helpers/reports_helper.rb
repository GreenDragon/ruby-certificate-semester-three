module ReportsHelper
private
  def create_referral_excel(referrals)
    titles = [ "Reference For", "Referrer", "Address", "City", "State", 
      "ZIP Code", "Day Phone", "Evening Phone", "Cell Phone", "E-Mail",
      "Known Years", "Known Months", "What Capacity", 
      "Working With Children", "Any Concerns?", "Role Model", "Reliability",
      "Creativity", "Enthusiasm", "Cultural Awareness", "Patience", 
      "Additional Comments", "Created At"
    ]

    fields = %w( reference_for name address city state zipcode day_phone 
      evening_phone cell_phone email known_years known_months what_capacity 
      working_with_children any_concerns role_model reliability creativity 
      enthusiasm cultural_awareness patience additional_comments created_at
    )

    build_excel_report(titles, fields, referrals)
  end

	def create_mentor_excel(mentors)
		#bold = wb.add_format(:bold => 1)
		#date = wb.add_format(:num_format => "yyyy/mm")
		#time = wb.add_format(:num_format => "yyyy/mm/dd hh:mm AM/PM")

    titles = [ "Name", "Address", "City", "State", "ZIP Code", 
      "Home Phone", "Cell Phone", "E-Mail", "Ethnicity", "Age", 
      "Afternoons?", "Evenings?", "Weekends?", "Org_1", "Title_1", 
      "Start_1", "Stop_1", "Org_2", "Title_2", "Start_2", "Stop_2", 
      "Org_3", "Title_3", "Start_3", "Stop_3", "Org_4", "Title_4", 
      "Start_4", "Stop_4", "Middle School Work", "Two Activities",
      "Helpful Support", "Seattle Location", "Brothers/Sisters", 
      "Have Children", "Have Pets", "Fav Subjects", "Hobbies/Interests",
      "Work Experience", "New Activities", "Describe Yourself", 
      "Why Mentor?", "Skill Sets", "Created On", "Latitude", "Longitude" 
    ]

    fields = %w( name address city state zipcode home_phone cell_phone
      email race age time_afternoon time_evening time_weekends exp_org_1
      exp_title_1 exp_start_1 exp_stop_1 exp_org_2 exp_title_2 exp_start_2 
      exp_stop_2 exp_org_3 exp_title_3 exp_start_3 exp_stop_3 exp_org_4 
      exp_title_4 exp_start_4 exp_stop_4 worked_with_middle_school 
      two_activities helpful_support seattle_location brothers_sisters 
      have_children have_pets fav_subject hobbies work_exp_mentee 
      new_activities_mentee describe_yourself why_be_a_mentor 
      what_skills_bring_you created_at lat lng
    )

    build_excel_report(titles, fields, mentors)
	end

  def build_excel_report(titles, fields, object)
    returning String.new do |str|
      str << "<html>\n<head></head>\n<body>\n<table border='1'>\n"
      str << "<tr>\n"

      titles.each { |title| str << "<th><strong>#{title}</strong></th>\n" }

      str << "</tr>\n"

      object.each do |o|
        str << "<tr>\n"

        fields.each do |field|
          if o.send(field).class == TrueClass
            str << "<td>#{o.send(field).to_s}</td>\n"
          elsif o.send(field).class == ActiveSupport::TimeWithZone
            if o.send(field)
              str << "<td>#{o.send(field).localtime.strftime("%Y/%m/%d")}</td     >\n"
            else
              str << "<td>&nbsp;</td>\n"
            end
          else
            str << "<td>#{o.send(field)}</td>\n"
          end
        end
        str << "</tr>\n"
      end
      str << "</table>\n</body>\n</html>"
    end
  end
end
