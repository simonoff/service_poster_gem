module SocialPusher

  module Postable

    module Base
      def self.included(base)
        base.class_attribute :social_pusher_as
        base.class_attribute :social_pusher_to
        base.extend ClassMethods
      end

      module ClassMethods
        def postable(*args)
          options = args.extract_options!
          self.social_pusher_as = options[:as]
          self.social_pusher_to = options[:to]
          include InstanceMethods
        end
      end

      module InstanceMethods

        def get_social_data
          __send__("get_social_data_for_#{self.social_pusher_as.to_s}".to_sym)
        end

        def get_social_data_for_post
          {
            :name => self.name,
            :body => self.body
          }
        end

        def get_social_data_for_event
          {
            :body => self.body,
            :start_time => self.date.to_time
          }
        end

        def get_social_poster(service)
          provider_class = service.provider.camelize
          act_as_class = self.social_pusher_as.to_s.camelize
          service_params = {
            :token => service.token,
            :secret => service.secret,
            :target => service.fb_page_id
          }
          "SocialPusher::#{provider_class}::#{act_as_class}".constantize.new(service_params)
        end

        def post_to_social(services)
          if self.user && self.user.social_services
            service_errors = {}
            services.each_value do |social_service|
              if social_service["id"]
                sid = social_service["id"].to_i
                ss = self.user.social_services.find(sid)
                data = get_social_data
                require 'pp'
                poster = get_social_poster(ss)
                begin
                  res = poster.create(data)
                end
                #begin
                #  res = ss.push_post(id, social_service["captcha"], social_service["captcha_id"])
                #  if res.is_a?(Array)
                #    if res[0] == :captcha
                #      service_errors[sid] = { :captcha => res[1]}
                #    end
                #  end
                #rescue => e
                #  service_errors[sid] = { :message => e }
                #end
              end
            end
            service_errors
          end
        end

      end

    end

  end

end

::ActiveRecord::Base.send :include, SocialPusher::Postable::Base