module Spree
  module CountryHelpers
    module ClassMethods
    end

    module InstanceMethods

      def set_session_country_by_ip
        @geoip ||= GeoIP.new("#{Rails.root.to_s}/db/GeoIP.dat")
        country_by_ip = @geoip.country(request.env['HTTP_X_FORWARDED_FOR'])
        Rails.logger.info "[GEO] request.remote_ip: #{request.remote_ip}"
        Rails.logger.info "[GEO] HTTP_X_FORWARDED_FOR: #{request.env['HTTP_X_FORWARDED_FOR']}"
        begin
          country = Spree::Country.where( "iso = ? OR iso3 = ?", country_by_ip.country_code2, country_by_ip.country_code3 ).first
        rescue
        end
        if country && !session[:country_id]
          session[:country_id] = country.id
          session[:country_name] = country.name
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.before_filter :set_session_country_by_ip
    end
  end
end
