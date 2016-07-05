# add matcher:
#     expect(page).to have_products(['Ruby on Rails Jr. Spaghetti', 'Ruby on Rails Baseball Jersey', 'Ruby on Rails Ringer T-Shirt'])
# instead of:
#     expect(page).to have_css("a[title='Ruby on Rails Ringer T-Shirt']")
#     expect(page).to have_css("a[title='Ruby on Rails Baseball Jersey']")
#     expect(page).to have_css("a[title='Ruby on Rails Jr. Spaghetti']")

module Capybara
  module RSpecMatchers

    class HaveProductsSelector < Matcher
      attr_reader :failure_message, :failure_message_when_negated

      def initialize(*args)
        @args = args
      end

      def matches?(actual)
        count_selector = HaveSelector.new(:css,'ul#products li', count: @args[1].count)
        res = count_selector.matches?(actual)
        @failure_message = selector.failure_message unless res

        @args[1].each do |product|
          selector = HaveSelector.new(:css, "a[title='#{product}']", {})
          selector_res = selector.matches?(actual)
          @failure_message = selector.failure_message unless selector_res
          res &&= selector_res
        end if res
        res
      rescue Capybara::ExpectationNotMet => e
        @failure_message = e.message
        return false
      end
    end

    def have_only_products(locator, options={})
      HaveProductsSelector.new(:products, locator, options)
    end
  end
end