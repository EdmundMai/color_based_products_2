require 'spec_helper'

describe Tax do
  its(:attributes) { should include "state_id" } 
  its(:attributes) { should include "zip_code" } 
  its(:attributes) { should include "rate" } 
  
  it { should belong_to(:state) }
  
  describe ".update_rate!(args={})" do
    context "state_code == 'NY'" do
      context "tax with the same zip code already exists" do
        it "updates the rate" do
          ny_state = FactoryGirl.create(:state, short_name: "NY")
          tax = FactoryGirl.create(:tax, zip_code: "10007", rate: 0.08, state_id: ny_state.id)
          Tax.update_rate!(zip_code: "10007", rate: 0.09, state_code: "NY")
          tax.reload
          expect(tax.rate).to eq(0.09)
        end
      end
    
      context "tax of zip_code does not exist" do
        it "creates a new record with the zip_code and rate" do
          ny_state = FactoryGirl.create(:state, short_name: "NY")
          Tax.update_rate!(zip_code: "10007", rate: 0.09, state_code: "NY")
          expect(Tax.where(zip_code: "10007", rate: 0.09, state_id: ny_state.id).first).not_to be_nil
        end
      end
    end
    
    context "args[:state_code] != 'NY'" do
      it "does nothing" do
        Tax.update_rate!(zip_code: "10007", rate: 0.09)
        expect(Tax.count).to eq(0)
      end
    end
  end
  
end
