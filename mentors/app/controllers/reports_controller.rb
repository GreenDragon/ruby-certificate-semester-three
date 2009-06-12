class ReportsController < ApplicationController
  include ReportsHelper

  def index
  end
	
  def mentors_excel
    @mentors = Mentor.find(:all, :order => :name)
    date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")

    # Hey, if I say call it .xls, then frakken call it that! Not .htm
    unless @mentors.empty?
      send_data create_mentor_excel(@mentors),
        :content_type => "application/vnd.ms-excel",
        :filename => "mentors_#{date}.xls"
    end
  end

  def referrals_excel
    @referrals = Referral.find(:all, :order => :reference_for)
    date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")

    unless @referrals.empty?
      send_data create_referral_excel(@referrals),
        :content_type => "application/vnd.ms-excel",
        :filename => "referrals_#{date}.xls"
    end
  end

  # see also: http://blog.edendevelopment.cookies.uk/2009/02/03/exporting-from-rails-to-excel/

  #def index
  #  @tasks = Task.find(:all)

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xls {
  #      require 'iconv'
  #      converter = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT','UTF-8')
  #      send_data(converter.iconv(generate_xls(@tasks)),
  #        :filename => 'all_tasks.xls',
  #        :type => 'application/vnd.ms-excel')
  #    }
  #  end
  #end
end
