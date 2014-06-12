require 'spec_helper'

describe State do
  its(:attributes) { should include "long_name" }
  its(:attributes) { should include "short_name" }
  
  it { should validate_uniqueness_of("short_name") }
  
  it { should have_many(:addresses) }
  
  describe ".new_york" do
    context "state with short_name == 'NY' exists" do
      it "returns state with short_name == 'NY'" do
        new_york = FactoryGirl.create(:state, short_name: "NY")
        expect(State.new_york).to eq(new_york)
      end
    end
    
    context "state with short_name == 'NY' does not exist" do
      it "returns nil" do
        expect(State.new_york).to be_nil
      end
    end
  end
end
