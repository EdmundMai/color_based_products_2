require 'spec_helper'

describe CartItem do
  its(:attributes) { should include "cart_id" }
  its(:attributes) { should include "variant_id" }
  its(:attributes) { should include "quantity" }
  
  it { should belong_to(:cart) }
  it { should belong_to(:variant) }
  it { should validate_presence_of(:cart) }
  it { should validate_presence_of(:variant) }
  
  describe "#total" do
    it "returns self.quantity * self.variant.price" do
      variant = FactoryGirl.create(:variant, price: 5.55)
      cart_item = FactoryGirl.create(:cart_item, quantity: 2, variant_id: variant.id)
      expect(cart_item.total).to eq(11.10)
    end
  end
  
  # describe "#variant" do
  #   context "variant exists" do
  #     it "returns the variant found using the item_identifier" do
  #       variant = FactoryGirl.create(:variant)
  #       cart_item = FactoryGirl.create(:cart_item, item_identifier: variant.id)
  #       expect(cart_item.variant).to eq(variant)
  #     end
  #   end
  # 
  #   context "variant does not exist" do
  #     it "returns nil" do
  #       cart_item = FactoryGirl.create(:cart_item, item_identifier: 999)
  #       expect(cart_item.variant).to be_nil
  #     end
  #   end
  # end
end
