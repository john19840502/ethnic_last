require 'spec_helper'
require 'helpers/products_matcher'


describe "Filter products", js: true do

  before(:each) do
    design_taxonomy = FactoryGirl.create(:taxonomy, :name => 'Design', :is_a_filter => true)
    root = design_taxonomy.root
    plain_taxon = FactoryGirl.create(:taxon, :name => 'Plain', :parent_id => root.id, taxonomy: design_taxonomy)
    nature_taxon = FactoryGirl.create(:taxon, :name => 'Nature', :parent_id => root.id, taxonomy: design_taxonomy)
    classic_taxon = FactoryGirl.create(:taxon, :name => 'Classic', :parent_id => root.id, taxonomy: design_taxonomy)

    composition_taxonomy = FactoryGirl.create(:taxonomy, :name => 'Composition', :is_a_filter => true)
    root = composition_taxonomy.root
    linen_taxon = FactoryGirl.create(:taxon, :name => 'Linen', :parent_id => root.id, taxonomy: composition_taxonomy)
    cotton_taxon = FactoryGirl.create(:taxon, :name => 'Cotton', :parent_id => root.id, taxonomy: composition_taxonomy)
    wool_taxon = FactoryGirl.create(:taxon, :name => 'Wool', :parent_id => root.id, taxonomy: composition_taxonomy)

    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Categories')
    root = taxonomy.root
    clothing_taxon = FactoryGirl.create(:taxon, :name => 'Clothing', :parent_id => root.id, taxonomy: taxonomy, filters: [design_taxonomy, composition_taxonomy])
    bags_taxon = FactoryGirl.create(:taxon, :name => 'Bags', :parent_id => root.id, taxonomy: taxonomy, filters: [design_taxonomy])
    mugs_taxon = FactoryGirl.create(:taxon, :name => 'Mugs', :parent_id => root.id, taxonomy: taxonomy)
    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Brands', :is_a_filter => true)
    root = taxonomy.root
    apache_taxon = FactoryGirl.create(:taxon, :name => 'Apache', :parent_id => root.id, taxonomy: taxonomy)
    rails_taxon = FactoryGirl.create(:taxon, :name => 'Ruby on Rails', :parent_id => root.id, taxonomy: taxonomy)
    ruby_taxon = FactoryGirl.create(:taxon, :name => 'RubyTest', :parent_id => root.id, taxonomy: taxonomy)


    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Mug', :price => '15.99', :taxons => [rails_taxon, mugs_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Tote', :price => '15.99', :taxons => [rails_taxon, bags_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Bag', :price => '22.99', :taxons => [rails_taxon, bags_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Stein', :price => '16.99', :taxons => [rails_taxon, mugs_taxon])

    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Ringer T-Shirt', :price => '19.99',
                       :taxons => [rails_taxon, clothing_taxon, linen_taxon, plain_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Baseball Jersey', :price => '19.99',
                       :taxons => [rails_taxon, clothing_taxon, cotton_taxon, plain_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Jr. Spaghetti', :price => '19.99',
                       :taxons => [rails_taxon, clothing_taxon, linen_taxon, nature_taxon, classic_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby Baseball Jersey', :price => '19.99',
                       :taxons => [ruby_taxon, clothing_taxon, wool_taxon, classic_taxon])
    FactoryGirl.create(:custom_product, :name => 'Apache Baseball Jersey', :price => '19.99',
                       :taxons => [apache_taxon, clothing_taxon, linen_taxon, plain_taxon, nature_taxon])
  end

  context 'User goes to products index' do
    before do
      page.driver.block_unknown_urls

      visit spree.products_path
      expect(page).to have_css('ul.categories', count: 2)
      expect(page).to have_css('ul#brand-list', count: 1)
      expect(page).to have_css('aside ul#brand-list li', count: 3)
    end

    describe 'and clicks "Clothing"' do
      before do
        click_link 'Clothing'
        expect(page).to have_text('COMPOSITION')
        expect(page).to have_css('ul#products li', count: 5)
      end

      it 'can filter products by taxons' do

        #Filter by linen
        click_link "Composition"
        click_link "Linen"
        expect(page).to have_only_products(['Apache Baseball Jersey', 'Ruby on Rails Ringer T-Shirt', 'Ruby on Rails Jr. Spaghetti'])

        #Filter by linen + plain
        click_link "Design"
        click_link "Plain"
        expect(page).to have_only_products(['Apache Baseball Jersey', 'Ruby on Rails Ringer T-Shirt'])

        #Filter by linen + plain + nature
        click_link "Nature"
        expect(page).to have_only_products(['Apache Baseball Jersey'])

        #Filter by linen + nature. Able to remove "plain" filter.
        click_link "Plain"
        expect(page).to have_only_products(['Apache Baseball Jersey', 'Ruby on Rails Jr. Spaghetti'])

      end

      it 'can filter products by brands' do

        #Filter by rails brand
        click_link "Brands"
        click_link "Ruby on Rails"
        expect(page).to have_only_products(['Ruby on Rails Jr. Spaghetti', 'Ruby on Rails Baseball Jersey', 'Ruby on Rails Ringer T-Shirt'])

        #Filter by rails + apache brands
        click_link "Apache"
        expect(page).to have_only_products(['Ruby on Rails Jr. Spaghetti', 'Ruby on Rails Baseball Jersey',
                                       'Ruby on Rails Ringer T-Shirt', 'Apache Baseball Jersey'])

        #Filter by apache only. Able to remove "rails" brand filter.
        click_link "Ruby on Rails"
        expect(page).to have_only_products(['Apache Baseball Jersey'])

      end

      it 'can filter product on brands and taxons' do

        #Filter by rails + linen
        click_link "Brands"
        click_link "Ruby on Rails"
        click_link "Composition"
        click_link "Linen"
        expect(page).to have_only_products(['Ruby on Rails Jr. Spaghetti', 'Ruby on Rails Ringer T-Shirt'])

        #Filter by rails + linen + plain
        click_link "Design"
        click_link "Plain"
        expect(page).to have_only_products(['Ruby on Rails Ringer T-Shirt'])

        #Filter by rails + plain. Able to remove "linen" filter.
        click_link "Linen"
        expect(page).to have_only_products(['Ruby on Rails Baseball Jersey', 'Ruby on Rails Ringer T-Shirt'])

        #Filter by plain. Able to remove "rails" brand filter.
        click_link "Ruby on Rails"
        expect(page).to have_only_products(['Ruby on Rails Baseball Jersey', 'Ruby on Rails Ringer T-Shirt', 'Apache Baseball Jersey'])
      end

    end
  end
end
