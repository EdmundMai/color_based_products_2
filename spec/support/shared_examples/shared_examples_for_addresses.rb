shared_examples_for "an address" do
  its(:attributes) { should include "first_name" }
  its(:attributes) { should include "last_name" }
  its(:attributes) { should include "street_address" }
  its(:attributes) { should include "street_address2" }
  its(:attributes) { should include "zip_code" }
  its(:attributes) { should include "phone_number" }
  its(:attributes) { should include "state_id" }
  its(:attributes) { should include "order_id" }
  its(:attributes) { should include "city" }
  its(:attributes) { should include "type" }
  
  it { should belong_to(:state) }
  it { should belong_to(:order) }
  
  describe "#full_name" do
    context "both first_name and last_name exist" do
      it "returns first_name and last_name concatenated with a space inbetween" do
        address = Address.new(first_name: "Net", last_name: "Theory")
        expect(address.full_name).to eq("Net Theory")
      end
    end
    
    context "only first_name exists" do
      it "returns first_name" do
        address = Address.new(first_name: "Net")
        expect(address.full_name).to eq("Net")
      end
    end
    
    context "only last_name exists" do
      it "returns last_name" do
        address = Address.new(last_name: "Theory")
        expect(address.full_name).to eq("Theory")
      end
    end
    
    context "neither first_name nor last_name exists" do
      it "returns an empty string" do
        address = Address.new
        expect(address.full_name).to eq("")
      end
    end
  end
  
  describe "#full_street_address" do
    context "both street_address and street_address2 exist" do
      it "returns street_address and street_address2 concatenated with a space inbetween" do
        address = Address.new(street_address: "7 Dey STreet", street_address2: "Suite 300")
        expect(address.full_street_address).to eq("7 Dey STreet Suite 300")
      end
    end
    
    context "only street_address exists" do
      it "returns street_address" do
        address = Address.new(street_address: "7 Dey STreet")
        expect(address.full_street_address).to eq("7 Dey STreet")
      end
    end
    
    context "only street_address2 exists" do
      it "returns street_address2" do
        address = Address.new(street_address2: "Suite 300")
        expect(address.full_street_address).to eq("Suite 300")
      end
    end
    
    context "neither street_address nor street_address2 exists" do
      it "returns an empty string" do
        address = Address.new
        expect(address.full_street_address).to eq("")
      end
    end
  end
  
  
end