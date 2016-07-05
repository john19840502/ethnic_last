module Spree
  class FavoritesMailer < BaseMailer
    add_template_helper(Spree::BaseHelper)
    include Spree::Core::Engine.routes.url_helpers

    default from: 'info@ethnicchic.com'

    def send_to_friend(email_to, email_from, message, favorites)
      @message = message
      @email_from = email_from
      @favorites = favorites
      mail to: email_to, subject: Spree.t('favorites_mail_title')
    end
  end
end