Spree::Admin::OptionTypesController.class_eval do
  def index
    respond_with(@collection) do |format|
      format.html
      format.json { render :json => json_data }
    end
  end

  def collection
    return @collection if @collection.present?
    unless request.xhr?
      params[:q] ||= {}
      params[:q][:s] ||= "name asc"

      @search = super.ransack(params[:q])
      @collection = @search.result.page(params[:page]).per(25)
    else
      @collection = super.where(["name #{LIKE} ?", "%#{params[:q]}%"])
      @collection = @collection.limit(params[:limit] || 10)
    end
    @collection
  end
end
