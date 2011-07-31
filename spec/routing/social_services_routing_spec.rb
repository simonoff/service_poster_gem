require "spec_helper"

describe SocialPusher::SocialServicesController do
  describe "routing" do

    it "routes to #index" do
      get("/social_services").should route_to("social_pusher/social_services#index")
    end

    it "routes to #create" do
      post("/social_services").should route_to("social_pusher/social_services#create")
    end

    it "routes to #update" do
      put("/social_services/1").should route_to("social_pusher/social_services#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/social_services/1").should route_to("social_pusher/social_services#destroy", :id => "1")
    end

  end
end
