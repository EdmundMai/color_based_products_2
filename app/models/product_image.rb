class ProductImage < ActiveRecord::Base
  mount_uploader :image, ProductImageUploader
  belongs_to :products_color
end
