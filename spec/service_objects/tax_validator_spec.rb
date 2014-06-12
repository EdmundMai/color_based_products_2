require 'spec_helper'

describe TaxValidator do
  describe "#new(zip_code)" do
    it "should set the zip_code variable" do
      tax_validator = TaxValidator.new(zip_code: "10001")
      expect(tax_validator.zip_code).to eq("10001")
    end
    it "should set the state_id variable" do
      tax_validator = TaxValidator.new(state_id: 1)
      expect(tax_validator.state_id).to eq(1)
    end
  end
  
  describe "#valid?" do
    context "the state_id is not New York" do
      it "returns true" do
        new_york = FactoryGirl.create(:new_york_state)
        other_state = FactoryGirl.create(:state, short_name: "MA")
        tax_validator = TaxValidator.new(zip_code: "10001", state_id: other_state.id)
        expect(tax_validator.valid?).to be_true
      end
    end
    context "the state_id is New York" do
      context "a tax for the zip_code cannot be found" do
        it "returns false" do
          new_york = FactoryGirl.create(:new_york_state)
          tax = FactoryGirl.create(:tax, state_id: new_york.id, zip_code: "99999")
          tax_validator = TaxValidator.new(zip_code: "10001", state_id: new_york.id)
          expect(tax_validator.valid?).to be_false
        end
        
        it "adds an error" do
          new_york = FactoryGirl.create(:new_york_state)
          tax = FactoryGirl.create(:tax, state_id: new_york.id, zip_code: "99999")
          tax_validator = TaxValidator.new(zip_code: "10001", state_id: new_york.id)
          tax_validator.valid?
          expect(tax_validator.errors.full_messages).to include("The zip code you entered is invalid. Please try again.")
        end
      end
      
      context "a tax for the zip_code can be found" do
        it "returns true" do
          new_york = FactoryGirl.create(:new_york_state)
          tax = FactoryGirl.create(:tax, state_id: new_york.id, zip_code: "10001")
          tax_validator = TaxValidator.new(zip_code: "10001", state_id: new_york.id)
          expect(tax_validator.valid?).to be_true
        end
      end
    end
  end
end
