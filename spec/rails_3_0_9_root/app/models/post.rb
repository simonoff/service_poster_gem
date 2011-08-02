class Post < ActiveRecord::Base

  belongs_to :user

  postable :to => [:twitter, :facebook, :vkontakte], :as => :post

end
