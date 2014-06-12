require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  
  describe ".vendor_options_with_extra_link_to_create_vendor" do
    it "returns an option for each Vendor, and one for creating a new vendor" do
      vendor = FactoryGirl.create(:vendor)
      expect(vendor_options_with_extra_link_to_create_vendor).to include "<option value=\"#{vendor.id}\">#{vendor.name}</option>"
      expect(vendor_options_with_extra_link_to_create_vendor).to include "<option value='' id='new_vendor_option'>Create a new vendor...</option>"
    end
  end
  
  describe ".color_options_with_extra_link_to_create_color" do
    it "returns an option for each color, and one for creating a new color" do
      color = FactoryGirl.create(:color)
      expect(color_options_with_extra_link_to_create_color).to include "<option value=\"#{color.id}\">#{color.name}</option>"
      expect(color_options_with_extra_link_to_create_color).to include "<option value='' id='new_color_option'>Create a new color...</option>"
    end
  end
end