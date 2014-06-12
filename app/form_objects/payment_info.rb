class PaymentInfo
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  def persisted?
    false
  end
  
  attribute :credit_card_number, String
  attribute :credit_card_exp_mm, String
  attribute :credit_card_exp_yyyy, String
  attribute :credit_card_cvv, String
  
  attribute :email, String
  attribute :password, String
  attribute :create_an_account, Boolean
  
  attribute :order_id, Integer
  attribute :shipping_address_first_name, String
  attribute :shipping_address_last_name, String
  attribute :shipping_address_street_address, String
  attribute :shipping_address_street_address2, String
  attribute :shipping_address_zip_code, String
  attribute :shipping_address_city, String
  attribute :shipping_address_state_id, Integer
  attribute :shipping_address_phone_number, String
  
  
  attribute :billing_address_first_name, String
  attribute :billing_address_last_name, String
  attribute :billing_address_street_address, String
  attribute :billing_address_street_address2, String
  attribute :billing_address_zip_code, String
  attribute :billing_address_city, String
  attribute :billing_address_state_id, Integer
  attribute :billing_address_phone_number, String
  
  validates_presence_of :email, if: ->(f) { f.user.guest? }
  validates_presence_of :password, if: ->(f) { f.create_an_account }
  
  
  validates_presence_of :shipping_address_first_name
  validates_presence_of :shipping_address_last_name
  validates_presence_of :shipping_address_street_address
  validates_presence_of :shipping_address_street_address2
  validates_presence_of :shipping_address_zip_code
  validates_presence_of :shipping_address_city
  validates_presence_of :shipping_address_state_id
  validates_presence_of :shipping_address_phone_number
  
  validates_presence_of :billing_address_first_name
  validates_presence_of :billing_address_last_name
  validates_presence_of :billing_address_street_address
  validates_presence_of :billing_address_street_address2
  validates_presence_of :billing_address_zip_code
  validates_presence_of :billing_address_city
  validates_presence_of :billing_address_state_id
  validates_presence_of :billing_address_phone_number
  
  validates_presence_of :credit_card_number
  validates_presence_of :credit_card_exp_mm
  validates_presence_of :credit_card_exp_yyyy
  validates_presence_of :credit_card_cvv

  validate do
    [shipping_address, billing_address, tax_validator, user, order].each do |object|
      unless object.valid?
        object.errors.each do |key, values|
          errors[key] = values
        end
      end
    end
  end
  
  def tax_validator
    @tax_validator ||= TaxValidator.new(zip_code: shipping_address.zip_code, state_id: shipping_address.state_id)
  end
  
  def user
    @user ||= User.find(order.user_id)
    if @user.guest?
      if create_an_account
        @user.assign_attributes(
          email: email,
          password: password,
          guest_email: nil,
          guest: false
        )
      else
        @user.assign_attributes(
          guest_email: email,
          guest: true
        )
      end
    end
    @user
  end

  def order
    @order ||= Order.find(order_id)
  end

  def shipping_address
    attrs = {        
        first_name: shipping_address_first_name,
        last_name: shipping_address_last_name,
        street_address: shipping_address_street_address,
        street_address2: shipping_address_street_address2,
        city: shipping_address_city,
        zip_code: shipping_address_zip_code,
        state_id: shipping_address_state_id,
        phone_number: shipping_address_phone_number
      }
    if order.shipping_address.present?
      order.shipping_address.assign_attributes(attrs)
      @shipping_address = order.shipping_address
    else
      @shipping_address = order.build_shipping_address(attrs)
    end
    @shipping_address
  end
  
  def billing_address
    attrs = {        
        first_name: billing_address_first_name,
        last_name: billing_address_last_name,
        street_address: billing_address_street_address,
        street_address2: billing_address_street_address2,
        city: billing_address_city,
        zip_code: billing_address_zip_code,
        state_id: billing_address_state_id,
        phone_number: billing_address_phone_number
      }
    if order.billing_address.present?
      order.billing_address.assign_attributes(attrs)
      @billing_address = order.billing_address
    else
      @billing_address = order.build_billing_address(attrs)
    end
    @billing_address
  end
  

  def save
    return false unless valid?
    process_billing_info!
  end
  
  private
  
    def process_billing_info!
      ActiveRecord::Base.transaction do
        billing_address.save!
        shipping_address.save!
        user.save!
        order.update_all_fees!
      end
    rescue Exception => e
      Rails.logger.info "Checkout form part 1 error: #{e.inspect}"
      # puts"Checkout form part 1 error: #{e.inspect}"
      false
    end

end
