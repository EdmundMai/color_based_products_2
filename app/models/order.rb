class Order < ActiveRecord::Base
  
  INCOMPLETE = 'Incomplete'
  IN_PROGRESS = 'In progress'
  
  belongs_to :user
  has_one :shipping_address, dependent: :destroy
  has_one :billing_address, dependent: :destroy
  
  has_many :line_items
  
  monetize :total_cents
  monetize :tax_cents
  monetize :subtotal_cents
  monetize :shipping_cents
  
  def update_all_fees!
    calculate_subtotal
    calculate_shipping
    calculate_tax
    calculate_total
    save!
  end
  
  def finalize_order!(cart)
    cart.cart_items.each do |cart_item|
      line_item = LineItem.new(cart_item.attributes.except("id", "cart_id"))
      line_item.unit_price = cart_item.variant.price
      line_item.order_id = self.id
      self.line_items << line_item
    end
    set_status_to_in_progress
    save
    cart.empty!
  end
  
  def set_status_to_in_progress
    self.update_attributes!(status: IN_PROGRESS)
  end
  
  def calculate_subtotal
    self.subtotal = user.cart.total
  end
  
  def calculate_shipping
    0
  end
  
  def calculate_tax
    if self.shipping_address.state && self.shipping_address.state == State.new_york
      corresponding_tax = Tax.find_by(zip_code: self.shipping_address.zip_code, state_id: self.shipping_address.state_id)
      self.tax = corresponding_tax.rate * (self.subtotal + shipping)
    else
      self.tax = 0.00
    end
  end
  
  def calculate_total
    self.total = self.subtotal + self.shipping + self.tax
  end
  
  
end
