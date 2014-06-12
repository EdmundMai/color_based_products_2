require 'spec_helper'

describe Variant do
  its(:attributes) { should include("products_color_id") }
  its(:attributes) { should include("measurements") }
  its(:attributes) { should include("weight") }
  its(:attributes) { should include("size_id") }
  its(:attributes) { should include("price_cents") }
  its(:attributes) { should include("price_currency") }
  its(:attributes) { should include("sku") }
  its(:attributes) { should include("in_stock") }

  
  it { should belong_to(:products_color) }
  it { should belong_to(:size) }
  
  it { should have_one(:product).through(:products_color) }
  
  it { should monetize(:price_cents).with_currency(:usd) }
  

  
end
