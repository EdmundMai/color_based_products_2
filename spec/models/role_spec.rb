require 'spec_helper'

describe Role do
  its(:attributes) { should include("name") }
  its(:attributes) { should include("resource_id") }
  its(:attributes) { should include("resource_type") }
end
