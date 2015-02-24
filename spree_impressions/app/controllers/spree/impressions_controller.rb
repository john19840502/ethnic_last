class Spree::ImpressionsController < Spree::BaseController

  def index
    @impressions = Spree::Impression.all
  end

  def show
    @impression = Spree::Impression.find(params[:id])
  end

  def accurate_title
    @impression ? "Impressions - #{@impression.name}" : "Impressions"
  end
end