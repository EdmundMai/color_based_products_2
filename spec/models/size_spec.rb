require 'spec_helper'

describe Size do
  its(:attributes) { should include("name") }
  its(:attributes) { should include("sort_order") }
  
  it { should have_many(:variants) }
end
