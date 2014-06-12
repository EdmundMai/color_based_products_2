class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  
  def add_item!(variant_id, qty)
    cart_item = self.cart_items.where(variant_id: variant_id).first_or_initialize
    cart_item.quantity ||= 0
    cart_item.quantity = valid_quantity(qty) + cart_item.quantity
    cart_item.save
  end
  
  
  def total
    cart_items.inject(Money.new(0, "USD")) do |total_price, cart_item|
      total_price = cart_item.total + total_price
      total_price
    end
  end
  
  def empty!
    cart_items.destroy_all
  end
  
  private
  
    def valid_quantity(quantity)
      if quantity.to_i > 0
        return quantity.to_i
      else
        return 1
      end
    end
  
end
