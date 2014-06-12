class Material < ActiveRecord::Base
  has_many :products
  
  validates_uniqueness_of :name
end
