class Event < ActiveRecord::Base
  
  belongs_to :user

  postable :to => [:twitter, :facebook, :vkontakte], :as => :event

end
