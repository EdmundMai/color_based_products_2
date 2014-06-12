class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :variant
  validates_presence_of :cart
  validates_presence_of :variant
  
  def total
    self.quantity * self.variant.price
  end
  
end
