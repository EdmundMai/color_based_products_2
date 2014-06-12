require 'spec_helper'

describe Order do
  its(:attributes) { should include("user_id") }
  its(:attributes) { should include("order_date") }
  its(:attributes) { should include("total_cents") }
  its(:attributes) { should include("total_currency") }
  its(:attributes) { should include("shipping_cents") }
  its(:attributes) { should include("shipping_currency") }
  its(:attributes) { should include("tax_cents") }
  its(:attributes) { should include("tax_currency") }
  its(:attributes) { should include("subtotal_cents") }
  its(:attributes) { should include("subtotal_currency") }
  its(:attributes) { should include("status") }
  
  it { should monetize(:total_cents).with_currency(:usd) }
  it { should monetize(:shipping_cents).with_currency(:usd) }
  it { should monetize(:tax_cents).with_currency(:usd) }
  it { should monetize(:subtotal_cents).with_currency(:usd) }
  
  it { should belong_to(:user) }
  it { should have_one(:shipping_address) }
  it { should have_one(:billing_address) }
  
  it { should have_many(:line_items) }

  describe "#calculate_tax" do
    context "shipping_address.state is not New York" do
      it "sets the tax to 0" do
        order = FactoryGirl.create(:order, subtotal: 10.00)
        state = FactoryGirl.create(:state)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, state_id: state.id)
        order.calculate_tax
        expect(order.tax).to eq(Money.new(0, "USD"))
      end
    end
    
    context "shipping_address.state is New York" do
      context "the zip code can be found" do
        it "sets the tax to a non-zero number" do
          order = FactoryGirl.create(:order, subtotal: 10.00)
          state = FactoryGirl.create(:state, short_name: "NY")
          tax = FactoryGirl.create(:tax, zip_code: "10001", rate: 0.08, state_id: state.id)
          shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, state_id: state.id, zip_code: "10001")
          order.calculate_tax
          expect(order.tax).to eq(Money.new(80, "USD"))
        end
      end

      context "the zip code can't be found" do
        it "raises an exception" do
          order = FactoryGirl.create(:order, subtotal: 10.00)
          state = FactoryGirl.create(:state, short_name: "NY")
          tax = FactoryGirl.create(:tax, zip_code: "10002", rate: 0.08, state_id: state.id)
          shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, state_id: state.id, zip_code: "10001")
          expect { order.calculate_tax }.to raise_error
        end
      end
    end
  end


  describe "#calculate_subtotal" do
    it "updates the subtotal" do
      user = FactoryGirl.create(:user)
      cart_item = FactoryGirl.create(:cart_item, cart_id: user.cart.id)
      order = FactoryGirl.create(:order, user_id: user.id, subtotal: nil)
      
      order.calculate_subtotal
      expect(order.subtotal).to eq(cart_item.variant.price)
    end
  end
  
  describe "calculate_shipping" do
    it "sets the shipping_cost to 0" do
      order = Order.new
      order.calculate_shipping
      expect(order.shipping).to eq(Money.new(0, "USD"))
    end
  end
  
  describe "calculate_total" do
    it "returns the sum of subtotal, tax, and shipping" do
      order = Order.new(subtotal: 11.11, shipping: 22.22, tax: 5.55)
      order.calculate_total
      expect(order.total).to eq(Money.new(3888, "USD"))
    end
  end

  describe "#update_all_fees!" do
    it "sends the calculate_subtotal method" do
      order = Order.new
      order.stub(:calculate_subtotal)
      order.stub(:calculate_shipping)
      order.stub(:calculate_tax)
      order.stub(:calculate_total)
      expect(order).to receive(:calculate_subtotal)
      order.update_all_fees!
    end
    
    it "sends the calculate_shipping method" do
      order = Order.new
      order.stub(:calculate_subtotal)
      order.stub(:calculate_shipping)
      order.stub(:calculate_tax)
      order.stub(:calculate_total)
      expect(order).to receive(:calculate_shipping)
      order.update_all_fees!
    end
    
    it "sends the calculate_tax method" do
      order = Order.new
      order.stub(:calculate_subtotal)
      order.stub(:calculate_shipping)
      order.stub(:calculate_tax)
      order.stub(:calculate_total)
      expect(order).to receive(:calculate_tax)
      order.update_all_fees!
    end
    
    it "sends the calculate_tax method" do
      order = Order.new
      order.stub(:calculate_subtotal)
      order.stub(:calculate_shipping)
      order.stub(:calculate_tax)
      order.stub(:calculate_total)
      expect(order).to receive(:calculate_total)
      order.update_all_fees!
    end
    
    it "sends the save! method" do
      order = Order.new
      order.stub(:calculate_subtotal)
      order.stub(:calculate_shipping)
      order.stub(:calculate_tax)
      order.stub(:calculate_total)
      expect(order).to receive(:save!)
      order.update_all_fees!
    end
  end
  
  describe "#set_status_to_in_progress" do
    it "sets the status to #{Order::IN_PROGRESS}" do
      order = Order.new
      order.set_status_to_in_progress
      expect(order.status).to eq(Order::IN_PROGRESS)
    end
  end
  
  describe "#finalize_order!(cart)" do
    it "calls the empty! method on cart" do
      cart = FactoryGirl.create(:cart)
      order = Order.new
      expect(cart).to receive(:empty!)
      order.finalize_order!(cart)
    end
    
    it "makes one line item for every cart item in the cart" do
      cart = FactoryGirl.create(:cart)
      cart.cart_items << FactoryGirl.create(:cart_item, cart_id: cart.id, quantity: 2)
      cart.cart_items << FactoryGirl.create(:cart_item, cart_id: cart.id)
      order = FactoryGirl.create(:order)
      expect { order.finalize_order!(cart) }.to change { order.line_items.count }.by(2)
    end
    
    it "copies the quantity and variant_id attribuets of the cart item into line item" do
      cart = FactoryGirl.create(:cart)
      cart_item = FactoryGirl.create(:cart_item, cart_id: cart.id)
      cart.cart_items << cart_item
      order = FactoryGirl.create(:order)
      order.finalize_order!(cart)
      expect(order.line_items.last.attributes.slice("quantity", "variant_id")).to eq(cart_item.attributes.slice("quantity", "variant_id"))
    end
    
    it "calls the set_status_to_in_progress method" do
      cart = FactoryGirl.create(:cart)
      order = Order.new
      expect(order).to receive(:set_status_to_in_progress)
      order.finalize_order!(cart)
    end
  end

end
