require 'spec_helper'

describe Cart do
  its(:attributes) { should include "user_id" }
  
  it { should belong_to(:user) }
  it { should have_many(:cart_items) }
  
  describe "#empty!" do
    it "destroys all cart_items" do
      cart = FactoryGirl.create(:cart)
      cart.cart_items << FactoryGirl.create(:cart_item, cart_id: cart.id)
      cart.empty!
      expect(cart.cart_items.count).to eq(0)
    end
  end
  
  describe "#total" do
    it "returns the total of the cart_item prices" do
      cart = FactoryGirl.create(:cart)
      variant = FactoryGirl.create(:variant, price: 12.25)
      cart.cart_items << FactoryGirl.create(:cart_item, quantity: 1, variant_id: variant.id)
      cart.cart_items << FactoryGirl.create(:cart_item, quantity: 2, variant_id: variant.id)
      expect(cart.total).to eq(Money.new(3675, "USD"))
    end
  end
  
  describe "#add_item!(variant_id, quanttiy)" do
    context "cart_item with same variant_id does not exist" do
      it "createa a new cart item with the given quanttiy" do
        cart = FactoryGirl.create(:cart)
        variant = FactoryGirl.create(:variant)
        cart.add_item!(variant.id, 2)
        expect(cart.cart_items.last.quantity).to eq(2)
      end
      
      it "createa a new cart item with the given variant_id" do
        cart = FactoryGirl.create(:cart)
        variant = FactoryGirl.create(:variant)
        cart.add_item!(variant.id, 2)
        expect(cart.cart_items.last.variant_id).to eq(variant.id)
      end
    end
    
    context "cart_item with same variant_id already exists" do
      it "adds the quantity to the already existing cart_item" do
        cart = FactoryGirl.create(:cart)
        variant = FactoryGirl.create(:variant)
        cart_item = FactoryGirl.create(:cart_item, variant_id: variant.id, quantity: 1)
        cart.cart_items << cart_item
        cart.add_item!(variant.id, 2)
        cart_item.reload
        expect(cart_item.quantity).to eq(3)
      end
    end
  end
  
end
