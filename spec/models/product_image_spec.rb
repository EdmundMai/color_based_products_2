require 'spec_helper'

describe ProductImage do
  its(:attributes) { should include("products_color_id") }
  its(:attributes) { should include("image") }
  its(:attributes) { should include("sort_order") }
  
  it { should belong_to(:products_color) }
end
