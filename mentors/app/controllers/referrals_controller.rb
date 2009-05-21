class ReferralsController < ApplicationController
  # GET /referrals/1
  # GET /referrals/1.xml
  def show
    @referral = Referral.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referral }
    end
  end

  # GET /referrals
  # GET /referrals/new
  # GET /referrals/new.xml
  def new
    @referral = Referral.new
    # @mentors = Mentor.find(:all, :order => name).map { |m| m.name }
    @referral.city = "Seattle"
    @referral.state = "WA"

    @referral.role_model = 3
    @referral.reliability = 3
    @referral.creativity = 3
    @referral.enthusiasm = 3
    @referral.cultural_awareness = 3
    @referral.patience = 3

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @referral }
    end
  end

  alias :index :new

  # POST /referrals
  # POST /referrals.xml
  def create
    @referral = Referral.new(params[:referral])

    respond_to do |format|
      if verify_recaptcha(:model => @referral) && @referral.save
        flash[:notice] = 'Referral was successfully created.'
        format.html { redirect_to(@referral) }
        format.xml  { render :xml => @referral, :status => :created, :location => @referral }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # These methods need to be wrapped by authentication

  # GET /referrals/1/edit
  def edit
    @referral = Referral.find(params[:id])
  end

  # PUT /referrals/1
  # PUT /referrals/1.xml
  def update
    @referral = Referral.find(params[:id])

    respond_to do |format|
      if @referral.update_attributes(params[:referral])
        flash[:notice] = 'Referral was successfully updated.'
        format.html { redirect_to(@referral) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @referral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /referrals/1
  # DELETE /referrals/1.xml
  def destroy
    @referral = Referral.find(params[:id])
    @referral.destroy

    respond_to do |format|
      format.html { redirect_to(referrals_url) }
      format.xml  { head :ok }
    end
  end
end
