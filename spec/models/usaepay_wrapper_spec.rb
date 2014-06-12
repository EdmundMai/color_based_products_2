require 'spec_helper'

describe UsaepayWrapper do
  
  describe "#initialize(args={})" do
    context "order was not provided" do
      it "raises an error" do
        expect { UsaepayWrapper.new }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Order with 'id'=order_was_not_provided")
      end
    end
    
    context "credit_card related keys are missing" do
      let(:order) { FactoryGirl.create(:order) }
      let(:usaepay) { 
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        UsaepayWrapper.new(
          order_id: order.id
        )
      }
    
      it "sets the transaction command attribute" do
        expect(usaepay.transaction.command).to eq("authonly")
      end
      
      it "sets the transaction card attribute" do
        expect(usaepay.transaction.card).to eq("")
      end
      
      it "sets the transaction cvv2 attribute" do
        expect(usaepay.transaction.cvv2).to eq("")
      end
      
      it "sets the transaction exp attribute" do
        expect(usaepay.transaction.exp).to eq(Date.today.strftime("%m%y"))
      end
      
      
      it "sets the transaction invoice attribute" do
        expect(usaepay.transaction.invoice).to eq(order.id)
      end
      
      it "sets the transaction cardholder attribute" do
        expect(usaepay.transaction.cardholder).to eq(order.billing_address.full_name)
      end
      
      it "sets the transaction street attribute" do
        expect(usaepay.transaction.street).to eq(order.billing_address.full_street_address)
      end
      
      it "sets the transaction zip attribute" do
        expect(usaepay.transaction.zip).to eq(order.billing_address.zip_code)
      end
    end
    

    
    context "credit_card_number, credit_card_exp_mm, credit_card_exp_yyyy, credit_card_cvv, and order_id are provided" do
      let(:order) { FactoryGirl.create(:order) }
      let(:usaepay) { 
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        UsaepayWrapper.new(
          credit_card_number: "4111111111111111",
          credit_card_exp_mm: "3",
          credit_card_exp_yyyy: "2033",
          credit_card_cvv: "123",
          order_id: order.id
        )
      }
      
      context "Rails.env is production" do
        before { Rails.stub_chain(:env, :production?) { true } }

        it "sets the transaction usesandbox attribute to false" do
          expect(usaepay.transaction.usesandbox).to be_false
        end
      end
      
      context "Rails.env is not production" do
        before { Rails.stub_chain(:env, :production?) { false } }

        it "sets the transaction usesandbox attribute to true" do
          expect(usaepay.transaction.usesandbox).to be_true
        end
      end
      
      it "sets the transaction usesandbox attribute to true" do
        expect(usaepay.transaction.usesandbox).to be_true
      end
    
      it "sets the transaction command attribute" do
        expect(usaepay.transaction.command).to eq("authonly")
      end
      
      it "sets the transaction card attribute" do
        expect(usaepay.transaction.card).to eq("4111111111111111")
      end
      
      it "sets the transaction cvv2 attribute" do
        expect(usaepay.transaction.cvv2).to eq("123")
      end
      
      it "sets the transaction exp attribute" do
        expect(usaepay.transaction.exp).to eq("0333")
      end
      
      it "sets the transaction invoice attribute" do
        expect(usaepay.transaction.invoice).to eq(order.id)
      end
      
      it "sets the transaction cardholder attribute" do
        expect(usaepay.transaction.cardholder).to eq(order.billing_address.full_name)
      end
      
      it "sets the transaction street attribute" do
        expect(usaepay.transaction.street).to eq(order.billing_address.full_street_address)
      end
      
      it "sets the transaction zip attribute" do
        expect(usaepay.transaction.zip).to eq(order.billing_address.zip_code)
      end
      
      it "sets the transaction amount attribute" do
        expect(usaepay.transaction.amount).to eq(order.total)
      end
    end
  end
  
  describe "#authorize" do
    
    let(:order) { FactoryGirl.create(:order) }
    let(:usaepay) { 
      billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
      UsaepayWrapper.new(
        credit_card_number: "4111111111111111",
        credit_card_exp_mm: "03",
        credit_card_exp_yyyy: "2033",
        credit_card_cvv: "123",
        order_id: order.id
      )
    }
    
    # context "the resultcode.to_s != 'A'" do
    #   it "raises an error" do
    #     expect(usaepay.authorize!).to raise_error
    #   end
    # end
    # 
    # context "the resultcode.to_s == 'A'" do 
    #   it "returns nil" do
    #     expect(usaepay.authorize!).to be_nil
    #   end
    # end
    
    
  end

  
end
