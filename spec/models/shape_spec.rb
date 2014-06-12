require 'spec_helper'

describe Shape do
  its(:attributes) { should include "name" }
  
  it { should have_many(:products) }
  
  it { should validate_uniqueness_of(:name) }
end
