require 'spec_helper'

describe "viewing products", type: :feature, inaccessible: true do

  context "taxon pages" do
    include_context "custom products"
    before do
      visit spree.root_path
    end

    it "should be able to visit brand Rails" do
      within(:css, '#taxonomies') { click_link "Rails" }

      expect(page.all('#products .product-list-item').size).to eq(7)
      tmp = page.all('#products .product-list-item a').map(&:text).flatten.compact
      tmp.delete("")
      array = ["Ruby on Rails Bag",
               "Ruby on Rails Baseball Jersey",
               "Ruby on Rails Jr. Spaghetti",
               "Ruby on Rails Mug",
               "Ruby on Rails Ringer T-Shirt",
               "Ruby on Rails Stein",
               "Ruby on Rails Tote"]
      expect(tmp.sort!).to eq(array)
    end

    it "should hide brand Ruby" do
      expect(page.find('#taxonomies')).not_to have_text("Ruby")
      expect(page.find('#taxonomies')).to have_text("Rails")
      expect(page.find('#taxonomies')).to have_text("Apache")
    end

    it "should be able to visit brand Apache and can't see products" do
      within(:css, '#taxonomies') { click_link "Apache" }

      expect(page.all('#products .product-list-item').size).to eq(0)
      tmp = page.all('#products .product-list-item a').map(&:text).flatten.compact
      tmp.delete("")
      expect(tmp.sort!).not_to eq(["Apache Baseball Jersey"])

      expect(page).to have_text("This very unique brand requires you to")
    end

    describe 'logged in user' do
      before do
        ApplicationController.any_instance.stub(:current_spree_user).and_return( create(:user) )
      end

      it "should be able to visit brand Apache" do
        within(:css, '#taxonomies') { click_link "Apache" }

        expect(page.all('#products .product-list-item').size).to eq(1)
        tmp = page.all('#products .product-list-item a').map(&:text).flatten.compact
        tmp.delete("")
        expect(tmp.sort!).to eq(["Apache Baseball Jersey"])
      end

      it "should be able to visit brand Invisible and can't see products" do
        within(:css, '#taxonomies') { click_link "Invisible" }

        expect(page.all('#products .product-list-item').size).to eq(0)
        tmp = page.all('#products .product-list-item a').map(&:text).flatten.compact
        tmp.delete("")
        expect(tmp.sort!).not_to eq(["Apache Baseball Jersey"])

        expect(page).to have_text("Prices for this brand is not available.")
      end
    end
  end
end