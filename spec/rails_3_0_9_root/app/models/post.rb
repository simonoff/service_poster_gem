class Post < ActiveRecord::Base

  belongs_to :user

  postable :to => [:twitter, :facebook], :as => :event

  def push_to_services(services)
    service_errors = {}
    services.each_value do |social_service|
      if social_service["id"]
        sid = social_service["id"].to_i
        ss = user.social_services.find(sid)
        begin
          res = ss.push_post(id, social_service["captcha"], social_service["captcha_id"])
          if res.is_a?(Array)
            if res[0] == :captcha
              service_errors[sid] = { :captcha => res[1]}
            end
          end
        rescue => e
          service_errors[sid] = { :message => e }
        end
      end
    end
    service_errors
  end
  
end
