class EventsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /events
  # GET /events.xml
  def index
    @events = current_user.events

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = current_user.events.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  rescue
    redirect_to events_url
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = current_user.events.build
    @services = current_user.social_services

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = current_user.events.find(params[:id])
    @services = current_user.social_services
  rescue
    redirect_to events_url
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_user.events.build(params[:event])
    @services = current_user.social_services

    respond_to do |format|
      if @event.save
        if params[:services]
          errors = @event.push_to_services(params[:services])
          if errors
            @service_errors = errors
            render :action => "edit" and return
          end
        end
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = current_user.events.find(params[:id])
    @services = current_user.social_services

    respond_to do |format|
      if @event.update_attributes(params[:event])
        if params[:services]
          errors = @event.push_to_services(params[:services])
          if errors
            @service_errors = errors
            render :action => "edit" and return
          end
        end
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  #rescue
  #  redirect_to events_url
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  rescue
    redirect_to events_url
  end
end
