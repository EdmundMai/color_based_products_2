require 'spec_helper'

describe ProductsColor do
  its(:attributes) { should include("color_id") }
  its(:attributes) { should include("product_id") }
  its(:attributes) { should include("mens") }
  its(:attributes) { should include("womens") }
  its(:attributes) { should include("mens_sort_order") }
  its(:attributes) { should include("womens_sort_order") }
  
  it { should have_many(:variants) }
  it { should have_many(:product_images) }
  
  it { should accept_nested_attributes_for(:variants) }
  it { should accept_nested_attributes_for(:product_images) }
  
  it { should belong_to(:product) }
  it { should belong_to(:color) }
  
  it { should validate_presence_of(:color) }
  
end
