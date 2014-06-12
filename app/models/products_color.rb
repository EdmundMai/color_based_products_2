class ProductsColor < ActiveRecord::Base
  has_many :variants, dependent: :destroy
  has_many :product_images, -> { order("sort_order ASC") }, dependent: :destroy
  
  accepts_nested_attributes_for :variants, :reject_if => proc { |attributes| attributes['size_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :product_images, :reject_if => proc { |attributes| attributes['image'].blank? }, :allow_destroy => true
  
  belongs_to :product
  belongs_to :color
  
  validates_presence_of :color
  
  def product_images_attributes=(attrs)
    if attrs[:image].present?
      attrs[:image].each do |image|
        self.product_images << ProductImage.new(image: image)
      end
    end
  end
  
  def variants_attributes=(attrs)
    if self.new_record?
      super(attrs)
    else
      attrs.each do |_, attributes|
        variant = Variant.where(size_id: attributes[:size_id], products_color_id: self.id).first_or_initialize
        variant.update_attributes(attributes)
      end
    end
  end
  
  
end
