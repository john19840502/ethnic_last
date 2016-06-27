module Spree
  class CountryController < BaseController

    def set
      if request.referer && request.referer.starts_with?('http://' + request.host)
        session['user_return_to'] = request.referer
      end
      if params[:country_id]
        country = Spree::Country.find(params[:country_id])
        if country

          session.delete(:country_id)
          session.delete(:country_name)

          session[:country_id] = country.id
          session[:country_name] = country.name

          flash.notice = t(:locale_changed)
        end
      else
        flash[:error] = t(:locale_not_changed)
      end

      redirect_back_or_default(root_path)
    end

    def set_currency
      if request.referer && request.referer.starts_with?('http://' + request.host)
        session['user_return_to'] = request.referer
      end
      session[:currency] = params[:currency] if params[:currency]
      flash.notice = "Currency changed"
      redirect_back_or_default(root_path)
    end

  end
end
