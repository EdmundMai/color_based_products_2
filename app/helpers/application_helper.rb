module ApplicationHelper
  
  def vendor_options_with_extra_link_to_create_vendor(selected=nil)
    options = options_from_collection_for_select(Vendor.all, :id, :name, selected)
    extra_link_to_create_vendor = "\n<option value='' id='new_vendor_option'>Create a new vendor...</option>".html_safe
    options.concat(extra_link_to_create_vendor)
  end
  
  def color_options_with_extra_link_to_create_color(selected=nil)
    options = options_from_collection_for_select(Color.all, :id, :name, selected)
    extra_link_to_create_color = "\n<option value='' id='new_color_option'>Create a new color...</option>".html_safe
    options.concat(extra_link_to_create_color)
  end
  
  def material_options_with_extra_link_to_create_material(selected=nil)
    options = options_from_collection_for_select(Material.all, :id, :name, selected)
    extra_link_to_create_material = "\n<option value='' id='new_material_option'>Create a new material...</option>".html_safe
    options.concat(extra_link_to_create_material)
  end
  
  def shape_options_with_extra_link_to_create_shape(selected=nil)
    options = options_from_collection_for_select(Shape.all, :id, :name, selected)
    extra_link_to_create_shape = "\n<option value='' id='new_shape_option'>Create a new shape...</option>".html_safe
    options.concat(extra_link_to_create_shape)
  end
  
end
