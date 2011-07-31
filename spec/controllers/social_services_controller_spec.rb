require 'spec_helper'

describe SocialPusher::SocialServicesController do

  before(:each) do
    [User, SocialService].each do |o|
      o.delete_all
    end
    @user = Factory.create(:user)
    sign_in @user
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SocialService" do
        expect {
          post :create
        }.to change(SocialService, :count).by(1)
      end
    end

  end

  describe "POST create with update" do
    describe "with valid params" do
      it "updates the requested social_service" do
        Factory.create(:social_service, :user => @user)
        SocialService.any_instance.should_receive(:update_attributes).with({
          :provider=>"twitter", :token=>"test_token", :secret=>"test_secret", :uid=>"123456790"
        })
        post :create
      end

    end

    describe "with invalid params" do
      it "not update service" do
        Factory.create(:social_service, :user => @user)
        SocialService.any_instance.stub(:save).and_return(false)
        request.env["omniauth.auth"] = {:test => 'test'}
        post :create
        response.should redirect_to(social_services_url)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested social_service" do
      social_service = Factory.create(:social_service, :user => @user)
      expect {
        delete :destroy, :id => social_service.id.to_s
      }.to change(SocialService, :count).by(-1)
    end

    it "redirects to the social_services list" do
      social_service = Factory.create(:social_service, :user => @user)
      delete :destroy, :id => social_service.id.to_s
      response.should redirect_to(social_services_url)
    end
  end

end
