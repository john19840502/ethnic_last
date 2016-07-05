Spree::Core::Search::Base.class_eval do

  def get_base_scope_with_visibility
    get_base_scope_without_visibility.available_to(@properties[:current_user])
  end

  def prepare_with_visibility(params)
    prepare_without_visibility(params)
    @properties[:current_user] = params[:current_user]
  end

  unless @search_initialized
    alias_method_chain :get_base_scope, :visibility
    alias_method_chain :prepare, :visibility
    @search_initialized = true
  end
end