FactoryGirl.define do

  factory :product_with_variants, :parent => :product do
    after(:create) { |product|
      sizes = %w(Small Medium Large X-Large).map{|i| create(:option_value_custom, :presentation => i) }
      colors = %w(Red Green Blue Yellow Purple Gray Black White).map{|i|
        create(:option_value_custom, :presentation => i, :option_type => Spree::OptionType.find_by_name("color") || create(:option_type_custom, :presentation => "Color"))
      }
      product.variants = sizes.map{|i| colors.map{|j| create(:variant, :product => product, :option_values => [i, j]) }}.flatten
      product.option_types = Spree::OptionType.where(:name => %w(size color))
    }
  end

  factory :variant_custom, :class => Spree::Variant do
    product { Spree::Product.last || create(:product) }
    option_values { [OptionValue.last || create(:option_value_custom)] }
    sequence(:sku) { |n| "ROR-#{1000 + n}" }
    sequence(:price) { |n| 19.99 + n }
    cost_price 17.00
    total_on_hand 10
  end

  factory :option_type_custom, :class => Spree::OptionType do
    presentation "Size"
    name { presentation.downcase }
    #sequence(:position) {|n| n }
  end

  factory :option_value_custom, :class => Spree::OptionValue do
    presentation "Large"
    name { presentation.downcase }
    option_type { Spree::OptionType.last || create(:option_type_custom) }
    #sequence(:position) {|n| n }
  end

  factory :stock_item_custom, class: Spree::StockItem do
    stock_location { Spree::StockLocation.last }
    variant

    after(:create) { |object| object.adjust_count_on_hand(10) }
  end

end
