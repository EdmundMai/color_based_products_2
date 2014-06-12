require 'spec_helper'

describe PaymentInfo do
  
  subject { 
    user = FactoryGirl.create(:user, guest: false)
    order = FactoryGirl.create(:order, user_id: user.id)
    PaymentInfo.new(order_id: order.id) 
  }
  
  its(:attributes) { should include(:credit_card_number) }
  its(:attributes) { should include(:credit_card_exp_mm) }
  its(:attributes) { should include(:credit_card_exp_yyyy) }
  its(:attributes) { should include(:credit_card_cvv) }

  
  its(:attributes) { should include(:email) }
  its(:attributes) { should include(:password) }
  its(:attributes) { should include(:create_an_account) }
  
  its(:attributes) { should include(:shipping_address_first_name) }
  its(:attributes) { should include(:shipping_address_last_name) }
  its(:attributes) { should include(:shipping_address_street_address) }
  its(:attributes) { should include(:shipping_address_street_address2) }
  its(:attributes) { should include(:shipping_address_zip_code) }
  its(:attributes) { should include(:shipping_address_city) }
  its(:attributes) { should include(:shipping_address_state_id) }
  its(:attributes) { should include(:billing_address_first_name) }
  its(:attributes) { should include(:billing_address_last_name) }
  its(:attributes) { should include(:billing_address_street_address) }
  its(:attributes) { should include(:billing_address_street_address2) }
  its(:attributes) { should include(:billing_address_zip_code) }
  its(:attributes) { should include(:billing_address_city) }
  its(:attributes) { should include(:billing_address_state_id) }
  
  it { should validate_presence_of(:shipping_address_first_name) }
  it { should validate_presence_of(:shipping_address_last_name) }
  it { should validate_presence_of(:shipping_address_street_address) }
  it { should validate_presence_of(:shipping_address_street_address2) }
  it { should validate_presence_of(:shipping_address_zip_code) }
  it { should validate_presence_of(:shipping_address_city) }
  it { should validate_presence_of(:shipping_address_state_id) }
  it { should validate_presence_of(:billing_address_first_name) }
  it { should validate_presence_of(:billing_address_last_name) }
  it { should validate_presence_of(:billing_address_street_address) }
  it { should validate_presence_of(:billing_address_street_address2) }
  it { should validate_presence_of(:billing_address_zip_code) }
  it { should validate_presence_of(:billing_address_city) }
  it { should validate_presence_of(:billing_address_state_id) }
  
  it { should validate_presence_of(:credit_card_number) }
  it { should validate_presence_of(:credit_card_cvv) }
  it { should validate_presence_of(:credit_card_exp_mm) }
  it { should validate_presence_of(:credit_card_exp_yyyy) }

  context "user is a guest" do
    subject { 
      user = FactoryGirl.create(:user, guest_email: "abc123@yahoo.com", guest: true)
      order = FactoryGirl.create(:order, user_id: user.id)
      PaymentInfo.new(order_id: order.id) 
    }
    
    it { should validate_presence_of(:email) }
  end
  
  context "create_an_account is true" do
    subject { 
      user = FactoryGirl.create(:user, guest_email: "abc123@yahoo.com", guest: true)
      order = FactoryGirl.create(:order, user_id: user.id)
      PaymentInfo.new(order_id: order.id, create_an_account: true) 
    }
    
    it { should validate_presence_of(:password) }
  end
    
  
  describe "#persisted?" do
    it "returns false" do
      expect(PaymentInfo.new.persisted?).to be_false
    end
  end
  
  describe "#save" do
    context "it is invalid" do
      it "returns false" do
        payment_info = PaymentInfo.new
        payment_info.stub(:valid?).and_return(:false)
        expect(payment_info.save).to be_false
      end
    end
    
    context "tax_validator validates unsuccessfully" do
      it "returns false" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.tax_validator.stub(:valid?).and_return(:false)
        expect(payment_info.save).to be_false
      end
    end
    
    context "billing_address saves unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        billing_address.stub(:save!).and_raise(StandardError)
        expect { payment_info.save }.not_to change { billing_address.updated_at }
        expect { payment_info.save }.not_to change { shipping_address.updated_at }
        expect { payment_info.save }.not_to change { order.user.updated_at }
      end
    end
    
    context "shipping_address saves unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        shipping_address.stub(:save!).and_raise(StandardError)
        expect { payment_info.save }.not_to change { billing_address.updated_at }
        expect { payment_info.save }.not_to change { shipping_address.updated_at }
        expect { payment_info.save }.not_to change { order.user.updated_at }
      end
    end
    
    context "user saves unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        order.user.stub(:save!).and_raise(StandardError)
        expect { payment_info.save }.not_to change { billing_address.updated_at }
        expect { payment_info.save }.not_to change { shipping_address.updated_at }
        expect { payment_info.save }.not_to change { order.user.updated_at }
      end
    end
    
    context "it is valid" do
      it "returns true" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        payment_info = PaymentInfo.new(order_id: order.id) 
        payment_info.stub(:valid?).and_return(:true)
        expect(payment_info.save).to be_true
      end
      
      context "a shipping address for the order already exists" do
        it "saves the shipping_address associated with the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      shipping_address_first_name: 'NewFirst',
                                      shipping_address_last_name: 'NewLast',
                                      shipping_address_street_address: 'NewStreet',
                                      shipping_address_street_address2: 'NewStreet2',
                                      shipping_address_zip_code: 'NewZip',
                                      shipping_address_city: 'NewCity',
                                      shipping_address_state_id: 999,
                                      shipping_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.save
          shipping_address.reload
          expect(shipping_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end

      
      context "a billing address for the order already exists" do
        it "saves the billing_address associated with the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      billing_address_first_name: 'NewFirst',
                                      billing_address_last_name: 'NewLast',
                                      billing_address_street_address: 'NewStreet',
                                      billing_address_street_address2: 'NewStreet2',
                                      billing_address_zip_code: 'NewZip',
                                      billing_address_city: 'NewCity',
                                      billing_address_state_id: 999,
                                      billing_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.save
          billing_address.reload
          expect(billing_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end

      context "a shipping address for the order does not exist" do
        it "creates a new shipping address for the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      shipping_address_first_name: 'NewFirst',
                                      shipping_address_last_name: 'NewLast',
                                      shipping_address_street_address: 'NewStreet',
                                      shipping_address_street_address2: 'NewStreet2',
                                      shipping_address_zip_code: 'NewZip',
                                      shipping_address_city: 'NewCity',
                                      shipping_address_state_id: 999,
                                      shipping_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.save
          expect(order.shipping_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end
      
      
      context "a billing address for the order does not exist" do
        it "creates a new billing address for the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      billing_address_first_name: 'NewFirst',
                                      billing_address_last_name: 'NewLast',
                                      billing_address_street_address: 'NewStreet',
                                      billing_address_street_address2: 'NewStreet2',
                                      billing_address_zip_code: 'NewZip',
                                      billing_address_city: 'NewCity',
                                      billing_address_state_id: 999,
                                      billing_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.save
          expect(order.billing_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end
      

      
      it "saves the user associated with the order" do
        user = FactoryGirl.create(:user, guest: true, guest_email: "blahafsd@yahoo.com")
        order = FactoryGirl.create(:order, user_id: user.id)
        payment_info = PaymentInfo.new(
                                    order_id: order.id,
                                    email: "new_email@yahoo.com",
                                    password: "something",
                                    create_an_account: true
                                    )
        payment_info.stub(:valid?).and_return(:true)
        payment_info.save
        user.reload
        expect(user.attributes).to include(
                                  "email" => "new_email@yahoo.com",
                                  "guest" => false,
                                  "guest_email" => nil
        )
      end
      
    end
  end

end