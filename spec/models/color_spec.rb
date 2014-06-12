require 'spec_helper'

describe Color do
  its(:attributes) { should include("name") }
  
  it { should have_many(:products_colors) }
  
  it { should validate_uniqueness_of(:name) }
  
end