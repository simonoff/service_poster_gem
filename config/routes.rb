Rails.application.routes.draw do
  match '/auth/:provider/callback' => 'social_pusher/social_services#create'
  scope :module => "social_pusher" do
    resources :social_services, :only => [:index,:create,:update,:destroy]
  end
end