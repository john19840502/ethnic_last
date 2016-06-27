Spree::FavoritesController.class_eval do

  before_action :set_page, only: [ :index, :send_email ]
  before_action :load_favorites, only: [:send_email]

  def send_email
    Spree::FavoritesMailer.send(
        :send_to_friend,
        params[:email_to],
        params[:email_from],
        params[:message],
        @favorites
    ).deliver
  end

  private
    def set_page
      @page = params[:page]
    end

    def load_favorites
      @favorites = Spree::Favorite.find(params[:favorites])
    end
end
