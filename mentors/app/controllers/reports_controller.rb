require "spreadsheet/excel"
include Spreadsheet

class ReportsController < ApplicationController
	def excel
		@mentors = Mentor.find(:all, :order => :name)
		date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")


		unless @mentors.empty?
			send_data create_excel(@mentors),
				:content_type => "application/xls",
				:filename => "mentors_#{date}.xls"
		end
	end

private

	def create_excel(mentors)
		report = StringIO.new

		wb = Excel.new(report)

		bold = wb.add_format(:bold => 1)
		date = wb.add_format(:num_format => "yyyy/mm")
		time = wb.add_format(:num_format => "yyyy/mm/dd hh:mm AM/PM")

		ws = wb.add_worksheet("Mentors")

		ws.write(0, 0, "Name", bold)
		ws.write(0, 1, "Address", bold)
		ws.write(0, 2, "City", bold)
		ws.write(0, 3, "State", bold)
		ws.write(0, 4, "ZIP Code", bold)
		ws.write(0, 5, "Home Phone", bold)
		ws.write(0, 6, "Cell Phone", bold)
		ws.write(0, 7, "E-Mail", bold)
		ws.write(0, 8, "Ethnicity", bold)
		ws.write(0, 9, "Age", bold)
		ws.write(0,10, "Afternoons?", bold)
		ws.write(0,11, "Evenings?", bold)
		ws.write(0,12, "Weekends?", bold)
		ws.write(0,13, "Org_1", bold)
		ws.write(0,14, "Title_1", bold)
		ws.write(0,15, "Start_1", bold)
		ws.write(0,16, "Stop_1", bold)
		ws.write(0,17, "Org_2", bold)
		ws.write(0,18, "Title_2", bold)
		ws.write(0,19, "Start_2", bold)
		ws.write(0,20, "Stop_2", bold)
		ws.write(0,21, "Org_3", bold)
		ws.write(0,22, "Title_3", bold)
		ws.write(0,23, "Start_3", bold)
		ws.write(0,24, "Stop_3", bold)
		ws.write(0,25, "Org_4", bold)
		ws.write(0,26, "Title_4", bold)
		ws.write(0,27, "Start_4", bold)
		ws.write(0,28, "Stop_4", bold)
		ws.write(0,29, "Middle School Work", bold)
		ws.write(0,30, "Two Activities", bold)
		ws.write(0,31, "Helpful Support", bold)
		ws.write(0,32, "Seattle Location", bold)
		ws.write(0,33, "Brothers/Sisters", bold)
		ws.write(0,34, "Have Children", bold)
		ws.write(0,35, "Have Pets", bold)
		ws.write(0,36, "Fav Subjects", bold)
		ws.write(0,37, "Hobbies Interests", bold)
		ws.write(0,38, "Work Experience", bold)
		ws.write(0,39, "New Activities", bold)
		ws.write(0,40, "Describe Yourself", bold)
		ws.write(0,41, "Why a Mentor", bold)
		ws.write(0,42, "What Skills Bring You", bold)
		ws.write(0,43, "Created On", bold)

		# data

		row = 1 

		mentors.each do |m|
			ws.write(row,  0, m.name)
			ws.write(row,  1, m.address)
			ws.write(row,  2, m.city)
			ws.write(row,  3, m.state)
			ws.write(row,  4, m.zipcode)
			ws.write(row,  5, m.home_phone)
			ws.write(row,  6, m.cell_phone)
			ws.write(row,  7, m.email)
			ws.write(row,  8, m.race)
			ws.write(row,  9, m.age)
			ws.write(row, 10, m.time_afternoon.to_s)
			ws.write(row, 11, m.time_evening.to_s)
			ws.write(row, 12, m.time_weekends.to_s)
			ws.write(row, 13, m.exp_org_1)
			ws.write(row, 14, m.exp_title_1)
			ws.write(row, 15, m.exp_start_1.strftime("%Y/%d"), date)	if m.exp_start_1
			ws.write(row, 16, m.exp_stop_1.strftime("%Y/%d"), date)		if m.exp_stop_1
			ws.write(row, 17, m.exp_org_2)
			ws.write(row, 18, m.exp_title_2)
			ws.write(row, 19, m.exp_start_1.strftime("%Y/%d"), date)	if m.exp_start_2
			ws.write(row, 20, m.exp_stop_2.strftime("%Y/%d"), date)		if m.exp_stop_2
			ws.write(row, 21, m.exp_org_3)
			ws.write(row, 22, m.exp_title_3)
			ws.write(row, 23, m.exp_start_3.strftime("%Y/%d"), date)	if m.exp_start_3
			ws.write(row, 24, m.exp_stop_3.strftime("%Y/%d"), date)		if m.exp_stop_3
			ws.write(row, 25, m.exp_org_4)
			ws.write(row, 26, m.exp_title_4)
			ws.write(row, 27, m.exp_start_4.strftime("%Y/%d"), date)	if m.exp_start_4
			ws.write(row, 28, m.exp_stop_4.strftime("%Y/%d"), date)		if m.exp_stop_4
			ws.write(row, 29, m.worked_with_middle_school)
			ws.write(row, 30, m.two_activities)
			ws.write(row, 31, m.helpful_support)
			ws.write(row, 32, m.seattle_location)
			ws.write(row, 33, m.brothers_sisters)
			ws.write(row, 34, m.have_children)
			ws.write(row, 35, m.have_pets)
			ws.write(row, 36, m.fav_subject)
			ws.write(row, 37, m.hobbies)
			ws.write(row, 38, m.work_exp_mentee)
			ws.write(row, 39, m.new_activities_mentee)
			ws.write(row, 40, m.describe_yourself)
			ws.write(row, 41, m.why_be_a_mentor)
			ws.write(row, 42, m.what_skills_bring_you)
			ws.write(row, 43, m.created_at.strftime("%Y/%m/%d %H:%M"), time)

			row += 1
		end

		wb.close
		report.string
	end
end
