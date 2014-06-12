class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :variant
  monetize :unit_price_cents
end
