require 'spec_helper'

describe Product do
  its(:attributes) { should include("name") }
  its(:attributes) { should include("short_description") }
  its(:attributes) { should include("long_description") }
  its(:attributes) { should include("active") }
  its(:attributes) { should include("page_title") }
  its(:attributes) { should include("meta_description") }
  its(:attributes) { should include("vendor_id") }
  its(:attributes) { should include("shape_id") }
  its(:attributes) { should include("material_id") }
  its(:attributes) { should include("taxable") }
  
  it { should belong_to(:vendor) }
  it { should belong_to(:shape) }
  it { should belong_to(:material) }
  it { should belong_to(:category) }
  
  it { should have_many(:products_colors) }
  it { should have_many(:variants).through(:products_colors) }
  it { should have_many(:product_images).through(:products_colors) }
  
  it { should accept_nested_attributes_for(:products_colors) }
  
end
