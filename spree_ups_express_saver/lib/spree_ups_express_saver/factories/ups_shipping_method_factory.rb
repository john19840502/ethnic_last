FactoryGirl.define do
  factory :ups_shipping_method, class: Spree::ShippingMethod do
    zones { |a| [Spree::Zone.global] }
    name 'UPS'
    code 'UPS'
    before(:create) do |shipping_method, evaluator|
      if shipping_method.shipping_categories.empty?
        shipping_method.shipping_categories << (Spree::ShippingCategory.first || create(:shipping_category))
      end
    end
    association(:calculator, factory: :ups_express_saver, strategy: :create)
  end
end