class MentorsController < ApplicationController
  # GET /mentors/1
  # GET /mentors/1.xml
  def show
    @mentor = Mentor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mentor }
    end
  end

  # GET /mentors
  # GET /mentors/new
  # GET /mentors/new.xml
  def new
    @mentor = Mentor.new
    @mentor.city = "Seattle"
	  @mentor.state = "WA"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mentor }
    end
  end

  alias :index :new

  # POST /mentors
  # POST /mentors.xml
  def create
    @mentor = Mentor.new(params[:mentor])

    respond_to do |format|
      if verify_recaptcha(:model => @mentor) && @mentor.save
        flash[:notice] = 'Mentor was successfully created.'
        format.html { redirect_to(@mentor) }
        format.xml  { render :xml => @mentor, :status => :created, :location => @mentor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mentor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Need to wrap these modes with authentication

  # GET /mentors/1/edit
  def edit
    @mentor = Mentor.find(params[:id])
  end

  # PUT /mentors/1
  # PUT /mentors/1.xml
  def update
    @mentor = Mentor.find(params[:id])

    respond_to do |format|
      if @mentor.update_attributes(params[:mentor])
        flash[:notice] = 'Mentor was successfully updated.'
        format.html { redirect_to(@mentor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mentor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mentors/1
  # DELETE /mentors/1.xml
  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy

    respond_to do |format|
      format.html { redirect_to(mentors_url) }
      format.xml  { head :ok }
    end
  end
end
