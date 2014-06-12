require 'spec_helper'

describe LineItem do
  its(:attributes) { should include("order_id") }
  its(:attributes) { should include("quantity") }
  its(:attributes) { should include("variant_id") }
  its(:attributes) { should include("unit_price_cents") }
  its(:attributes) { should include("unit_price_currency") }
  it { should belong_to(:order) }
  it { should belong_to(:variant) }
  it { should monetize(:unit_price_cents).with_currency(:usd) }  
end
