module SocialPusher
  class SocialServicesController < ApplicationController
    unloadable

    before_filter :authenticate_user!

    def index
      @social_services = current_user.social_services
    end

    def create
      data = SocialService.get_auth_info(request.env['omniauth.auth'])
      redirect_to :action => :index and return unless data
      if SocialService.auth_token_exists?(current_user.id, data[:provider], data[:uid])
        social_service = current_user.social_services.where(:provider => data[:provider], :uid => data[:uid]).first
        social_service.update_attributes(data)
      else
        social_service = current_user.social_services.build(data)
        social_service.save
      end
      redirect_to :action => :index
    end

    def update
      @social_service = SocialService.find(params[:id])
      if @social_service.update_attributes(params[:social_service])
        notice = 'social service updated successfully'
      else
        notice = 'social service wasn\'t updated successfully'
      end
      redirect_to(:action => :index, :notice => notice)
    end

    def destroy
      @social_service = SocialService.find(params[:id])
      @social_service.destroy
      redirect_to :action => :index
    end
  end
end
