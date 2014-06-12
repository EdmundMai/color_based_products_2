class Size < ActiveRecord::Base
  has_many :variants
  
  default_scope { order('sort_order ASC') }
end
