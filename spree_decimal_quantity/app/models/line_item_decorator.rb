Spree::LineItem.class_eval do
  #remove validations on

  _validators.reject!{ |key, _| key == :quantity }

  matches = _validate_callbacks.select do |callback|
    callback.raw_filter.is_a?(ActiveModel::Validations::NumericalityValidator) &&
                                  callback.raw_filter.attributes.include?(:quantity)
  end

  _validate_callbacks.delete(matches.first)
end
