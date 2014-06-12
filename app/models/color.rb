class Color < ActiveRecord::Base
  has_many :products_colors
  validates_uniqueness_of :name
end
