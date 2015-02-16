Spree::Core::Search::Base.class_eval do

  def get_base_scope_with_visibility
    bscope = get_base_scope_without_visibility.available_to(@properties[:current_user])
    Rails.logger.error @properties[:current_user].inspect
    Rails.logger.error bscope.count
    bscope
  end

  def prepare_with_visibility(params)
    prepare_without_visibility(params)
    @properties[:current_user] = params[:current_user]
  end

  alias_method_chain :get_base_scope, :visibility
  alias_method_chain :prepare, :visibility
end