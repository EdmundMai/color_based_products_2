class Vendor < ActiveRecord::Base
  default_scope { order(name: :asc) }
  
  has_many :products
  
  validates_uniqueness_of :name
end
