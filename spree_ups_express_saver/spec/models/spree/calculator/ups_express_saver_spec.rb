require 'spec_helper'

describe Spree::Calculator::UpsExpressSaver do
  let(:calculator) { Spree::Calculator::UpsExpressSaver.new }

  context "compute" do
    let!(:object) { double("Package") }

    it "amount with nil object" do
      calculator.compute_package(nil).round(2).should == 0.0
    end

    it "amount with 0 from calc" do
      object.stub(:weight) { 0 }
      calculator.compute_package(object).round(2).should == 0.0
    end

    it "will return the preferred_starting_price when < min_weight" do
      object.stub(:weight) { 1400 }
      # total weight 1400
      calculator.stub(:preferred_min_weight_kg) { 3 }
      calculator.stub(:preferred_starting_price) { 13.25 }
      calculator.stub(:preferred_price_per_kg) { 0.25 }
      calculator.compute_package(object).round(2).should == 13.25
    end

    it "will return the preferred_starting_price when == min_weight" do
      object.stub(:weight) { 3000 }
      # total weight 3000
      calculator.stub(:preferred_min_weight_kg) { 3 }
      calculator.stub(:preferred_starting_price) { 13.25 }
      calculator.stub(:preferred_price_per_kg) { 0.25 }
      calculator.compute_package(object).round(2).should == 13.25
    end

    it "will add the next amount when its just bigger min_weight." do
      object.stub(:weight) { 3300 }
      # total weight 3300
      calculator.stub(:preferred_min_weight_kg) { 3 }
      calculator.stub(:preferred_starting_price) { 13.25 }
      calculator.stub(:preferred_price_per_kg) { 0.25 }
      calculator.compute_package(object).round(2).should == 13.50
    end

    it "calculates the correct amount for heavy stuff" do
      object.stub(:weight) { 33000 }
      # total weight 33000
      calculator.stub(:preferred_min_weight_kg) { 3 }
      calculator.stub(:preferred_starting_price) { 13.25 }
      calculator.stub(:preferred_price_per_kg) { 0.25 }
      calculator.compute_package(object).round(2).should == 20.75
    end

  end

  describe "service_name" do
    it "should return description when not defined" do
      calculator.class.service_name.should == calculator.description
    end
  end
end