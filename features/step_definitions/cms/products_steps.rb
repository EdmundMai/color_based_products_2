Given(/^existing products$/) do
  FactoryGirl.create_list(:product, 2)
end

Given(/^existing colors$/) do
  FactoryGirl.create_list(:color, 2)
end

Given(/^existing vendors$/) do
  FactoryGirl.create_list(:vendor, 2)
end

Given(/^existing shapes$/) do
  FactoryGirl.create_list(:shape, 2)
end

Given(/^existing categories$/) do
  FactoryGirl.create_list(:category, 2)
end

Given(/^existing materials$/) do
  FactoryGirl.create_list(:material, 2)
end

Given(/^existing sizes$/) do
  FactoryGirl.create_list(:size, 2)
end

Given(/^an existing complete product$/) do
  FactoryGirl.create(:complete_product)
end

When(/^I visit the admin products edit page$/) do
  product = Product.last
  visit edit_admin_product_path(product)
end

When(/^I change the sort order for (.*) colors$/) do |section|
  pending "jQuery UI Sortable is currently not testable in Rails using Capybara / Selenium for horizontal lists"
  within(".sorted_product_#{section}_color_list") do
    # first_color = page.find_by_id(ProductsColor.first.id)
    # last_color = page.find_by_id(ProductsColor.last.id)
    # 
    # sleep 5
    # distance = 1
    # page.execute_script %{
    #     $("li##{ProductsColor.last.id}").simulateDragSortable({ move: #{distance.to_i}});
    # }
    # sleep 1# Hack to ensure ajax finishes running (tweak/remove as needed for your suite)
    
    # selenium_webdriver = page.driver.browser
    # selenium_webdriver.mouse.down(first_color.native)
    # selenium_webdriver.mouse.move_to(last_color.native, 0, 10)
    # selenium_webdriver.mouse.up
    # sleep 3
  end
end

Then(/^the sort orders for men's colors should be updated$/) do
  expect(ProductsColor.first.mens_sort_order).to be > ProductsColor.last.mens_sort_order
end


Then(/^the sort orders for women's colors should be updated$/) do
  expect(ProductsColor.first.womens_sort_order).to be > ProductsColor.last.womens_sort_order
end


When(/^I visit the admin products index page$/) do
  visit admin_products_path
end

Then(/^I should see a list of products information$/) do
  expect(Product.count).to be > 0
  Product.all.each do |product|
    expect(page).to have_content(product.name)
  end
end

When(/^I visit the admin products new page$/) do
  visit new_admin_product_path
end

When(/^I fill in the form to create a new product$/) do
  fill_in("product[name]", with: "Lorem")
  fill_in("product[short_description]", with: "Ipsum")
  fill_in("product[long_description]", with: "Something")
  fill_in("product[page_title]", with: "My Page Title")
  fill_in("product[meta_description]", with: "My Meta Description")
  select(Vendor.last.name, from: "product[vendor_id]")
  select(Material.last.name, from: "product[material_id]")
  select(Shape.last.name, from: "product[shape_id]")
  select(Category.last.name, from: "product[category_id]")
  
  expect(find(:css, "#product_taxable")).to be_checked
end

When(/^I generate multiple variants$/) do
  fill_in("price", with: "11.11")
  
  first_size_inputs = first(".size_inputs")
  within(first_size_inputs) do
    select(Size.first.name, from: "size")
    fill_in("measurements", with: "12-12-12")
    fill_in("weight", with: "5.00")
  end

  click_link("Add Size")
  sleep 1
  last_size_inputs = page.all(".size_inputs")[-1]
  within(last_size_inputs) do
    select(Size.last.name, from: "size")
    fill_in("measurements", with: "24-24-24")
    fill_in("weight", with: "19.05")
  end
  
  select(Color.first.name, from: "color")
  first_mens_checkbox = page.all(".genders")[0]
  first_womens_checkbox = page.all(".genders")[1]
  expect(first_mens_checkbox).to be_checked
  expect(first_womens_checkbox).to be_checked
  
  click_link("Add Color")
  sleep 1
  
  second_mens_checkbox = page.all(".genders")[2]
  second_womens_checkbox = page.all(".genders")[3]
  expect(second_mens_checkbox).to be_checked
  expect(second_womens_checkbox).to be_checked
  
  last_color_inputs = page.all(".color_inputs")[1]
  within(last_color_inputs) do
    select(Color.last.name, from: "color")
    find(:css, ".genders:last-of-type").set(false)
  end
  
  click_link("Generate")
  sleep 1
  
  within(".variant_container") do
    expect(page).to have_css("table.variants_table tr", count: 5)
    expect(page).to have_select("product[products_colors_attributes][0][variants_attributes][0][size_id]", with_options: [Size.first.name])
    expect(page).to have_select("product[products_colors_attributes][0][variants_attributes][1][size_id]", with_options: [Size.last.name])
    expect(page).to have_select("product[products_colors_attributes][1][variants_attributes][0][size_id]", with_options: [Size.first.name])
    expect(page).to have_select("product[products_colors_attributes][1][variants_attributes][1][size_id]", with_options: [Size.last.name])
    
    expect(page).to have_content(Color.first.name)
    expect(page).to have_content(Color.last.name)
  end
  
  (0..1).each do |pc_index|
    fill_in("product[products_colors_attributes][#{pc_index}][variants_attributes][0][price]", with: "11.22")
    fill_in("product[products_colors_attributes][#{pc_index}][variants_attributes][0][sku]", with: "ABC123")
    fill_in("product[products_colors_attributes][#{pc_index}][variants_attributes][0][weight]", with: "5.0")
    fill_in("product[products_colors_attributes][#{pc_index}][variants_attributes][1][price]", with: "11.22")
    fill_in("product[products_colors_attributes][#{pc_index}][variants_attributes][1][sku]", with: "ABC123")
    fill_in("product[products_colors_attributes][#{pc_index}][variants_attributes][0][weight]", with: "19.05")
  end
end

When(/^I submit the product form$/) do
  click_button("Create Product")
end


Then(/^my product should be saved$/) do
  expect(Product.count).to eq(1)
  product = Product.last
  expect(product.name).to eq("Lorem");
  expect(product.short_description).to eq("Ipsum")
  expect(product.long_description).to eq("Something")
  expect(product.page_title).to eq("My Page Title")
  expect(product.meta_description).to eq("My Meta Description")
  expect(product.active).to be_false
  expect(product.taxable).to be_true
  
  expect(product.vendor).to eq Vendor.last
  expect(product.material).to eq Material.last
  expect(product.shape).to eq Shape.last
  expect(product.category).to eq Category.last
  
  expect(product.variants.count).to eq(4)
  expect(product.variants.where(size: "S", 
                         measurements: "12-12-12",
                         men: true,
                         women: true,
                         price: 11.22,
                         sku: "ABC123",
                         color_id: Color.first.id)).not_to be_nil
   expect(product.variants.where(size: "S", 
                          measurements: "12-12-12",
                          men: true,
                          women: false,
                          price: 11.22,
                          sku: "ABC123",
                          color_id: Color.last.id)).not_to be_nil
                          
  expect(product.variants.where(size: "M", 
                         measurements: "24-24-24",
                         men: true,
                         women: true,
                         price: 11.22,
                         sku: "ABC123",
                         color_id: Color.first.id)).not_to be_nil
   expect(product.variants.where(size: "S", 
                         measurements: "24-24-24",
                         men: true,
                         women: false,
                         price: 11.22,
                         sku: "ABC123",
                         color_id: Color.last.id)).not_to be_nil
end

When(/^I try to generate a variant combination without selecting a size$/) do
  select(Color.first.name, from: "variant[color][]")
  click_link("Generate")
end

Then(/^I should be prompted to select a size$/) do
  expect(page).to have_content("Please select a size.")
end

Then(/^I should be on the edit product page$/) do
  product = Product.last
  expect(current_path).to eq(edit_admin_product_path(product))
end

When(/^I add a vendor$/) do
  find("option[id='new_vendor_option']").click
  fill_in("vendor[name]", with: "Gucci")
  find(:id, 'new_vendor_text_field').native.send_keys(:enter)
end

Then(/^that vendor should be available in the the product form$/) do 
  expect(page).to have_select("product[vendor_id]", with_options: ["Gucci"])
end

Then(/^"(.*?)" should be on the color list$/) do |color_name|
  expect(page).to have_select("color", options: [color_name, "Create a new color..."])
end

When(/^I add a color$/) do
  find("#new_color_option").click
  fill_in("color[name]", with: "Aqua")
  find('#new_color_text_field').native.send_keys(:return)
end

Then(/^that color should be available in the variant generator color form$/) do
  expect(page).to have_select("color", with_options: ["Aqua"])
end


When(/^I add a material$/) do
  find("#new_material_option").click
  fill_in("material[name]", with: "Plastic")
  find('#new_material_text_field').native.send_keys(:return)
end

Then(/^that material should be available in the product form$/) do
  expect(page).to have_select("product[material_id]", with_options: ["Plastic"])
end

When(/^I add a shape$/) do
  find("#new_shape_option").click
  fill_in("shape[name]", with: "Gucci")
  find('#new_shape_text_field').native.send_keys(:return)
end

Then(/^that shape should be available in the the product form$/) do
  expect(page).to have_select("product[shape_id]", with_options: ["Gucci"])
end


When(/^I create a new variant for an existing color$/) do
  first_color = first(".fields")
  within(first_color) do
    click_link("Add Variant")
    new_variant_div = page.all(:css, ".variant_container")[-1]
    within(new_variant_div) do
      page.all(:css, "option")[-1].click
      fill_in("Price", with: "11.22") 
      fill_in("Measurements", with: "11-11-11") 
      fill_in("Sku", with: "NEWSKU") 
      fill_in("Weight", with: "1.22")
      check("In stock") 
    end
  end
end

When(/^I create a new products color$/) do
  click_link("Add Color")
  new_color_div = page.all(:css, ".color_container")[-1]
  within(new_color_div) do
    color_select = page.all(:css, "select")[0]
    within(color_select) do
      page.all(:css, "option")[-1].click
    end
    fill_in("color[name]", with: "Purple")
    find('#new_color_text_field').native.send_keys(:return)
    attach_file('Add Images', File.join(Rails.root, 'spec', 'support', 'sample_img.jpg'))
    check("Men's")
    check("Women's")
    fill_in("Price", with: "11.22") 
    fill_in("Measurements", with: "11-11-11") 
    fill_in("Sku", with: "NEWSKU") 
    fill_in("Weight", with: "1.22")
    check("In stock") 
  end
end

Then(/^my products color should be saved$/) do
  product = Product.last

  expect(product.products_colors.count).to eq(1)
  
  products_color = product.products_colors.last
  expect(products_color.product).to eq Product.last
  expect(products_color.mens).to be_true
  expect(products_color.womens).to be_true
  expect(products_color.product_images).not_to be_empty
  expect(products_color.color).to eq Color.last  

  expect(products_color.variants.count).to eq(1)
  
  products_color.variants.each do |variant|
    expect(variant.size).to eq(Size.first)
    expect(variant.price).to eq(11.22)
    expect(variant.measurements).to eq("11-11-11")
    expect(variant.sku).to eq("NEWSKU")
    expect(variant.weight).to eq(1.22)
    expect(variant.in_stock).to be_true
  end
end

When(/^I update my product$/) do
  click_button("Update Product")
end

Then(/^my variant should be saved$/) do
  expect(page).to have_content "Your product was successfully updated."
  
  product = Product.last
  last_variant = product.variants.last
  expect(last_variant.size).to eq(Size.last)
  expect(last_variant.price).to eq(11.22)
  expect(last_variant.measurements).to eq("11-11-11")
  expect(last_variant.sku).to eq("NEWSKU")
  expect(last_variant.weight).to eq(1.22)
  expect(last_variant.in_stock).to be_true
end

When(/^I delete the last color$/) do
  product = Product.last
  expect(product.products_colors.count).to eq 2
  last_color_div = page.all(:css, ".color_container")[-1]
  within(last_color_div) do
    first(:link, "Delete").click
  end
end

Then(/^that color should be deleted$/) do
  product = Product.last
  expect(product.products_colors.count).to eq 1
end

When(/^I delete the last variant of the last color$/) do
  product = Product.last
  expect(product.variants.count).to eq 2
  first_variant_div = first(".variant_container")
  within(first_variant_div) do
    click_link("Delete")
  end
end

Then(/^that variant should be deleted$/) do
  product = Product.last
  expect(product.variants.count).to eq 1
end

When(/^I add a variant of a different size but with the same color$/) do
  product = Product.last
  
  click_link("Add Color")
  new_color_div = page.all(:css, ".color_container")[-1]
  within(new_color_div) do
    attach_file('Add Images', File.join(Rails.root, 'spec', 'support', 'sample_img.jpg'))
    check("Men's")
    check("Women's")
    
    color_select = page.all(:css, "select")[0]
    within(color_select) do
      page.all(:option, product.products_colors.last.color.name)[0].click
    end
    
    new_variant_div = page.all(:css, ".variant_container")[-1]
    within(new_variant_div) do
      page.all(:option, Size.last.name)[0].click

      fill_in("Price", with: "11.22") 
      fill_in("Measurements", with: "11-11-11") 
      fill_in("Sku", with: "NEWSKU") 
      fill_in("Weight", with: "1.22")
      check("In stock") 
    end
  end
  
end

Then(/^there should only be one product color of that color$/) do
  product = Product.last
  pc = product.products_colors.last
  expect(pc.color.products_colors.count).to eq 1
end

Then(/^that product color should have a new variant$/) do
  product = Product.last
  pc = product.products_colors.last
  expect(pc.variants.count).to eq 2
  expect(pc.mens).to be_true
  expect(pc.womens).to be_true
  
  last_variant = pc.variants.last
  expect(last_variant.price).to eq(11.22)
  expect(last_variant.measurements).to eq("11-11-11")
  expect(last_variant.sku).to eq("NEWSKU")
  expect(last_variant.weight).to eq(1.22)
  expect(last_variant.in_stock).to be_true
end


When(/^I delete the last product image$/) do
  expect(ProductImage.count).to eq(2)
  image_list = first(".sorted_product_image_list")
  within(image_list) do
    within("li:last") do
      first(:link).click
    end
  end
end

Then(/^that image should be deleted$/) do
  expect(ProductImage.count).to eq(1)
end

When(/^I add a variant of the same size and color$/) do
  product = Product.last
  products_color = product.products_colors.last
  expect(products_color.variants.count).to eq(1)

  click_link("Add Color")
  new_color_div = page.all(:css, ".color_container")[-1]
  within(new_color_div) do
    attach_file('Add Images', File.join(Rails.root, 'spec', 'support', 'sample_img.jpg'))
    check("Men's")
    check("Women's")
    
    color_select = page.all(:css, "select")[0]
    within(color_select) do
      page.all(:option, products_color.color.name)[0].click
    end
    
    new_variant_div = page.all(:css, ".variant_container")[-1]
    within(new_variant_div) do
      page.all(:option, products_color.variants.last.size.name)[0].click

      fill_in("Price", with: "11.22") 
      fill_in("Measurements", with: "11-11-11") 
      fill_in("Sku", with: "NEWSKU") 
      fill_in("Weight", with: "1.22")
      check("In stock") 
    end
  end
end

Then(/^there should only be one variant of that product color and size$/) do
  product = Product.last
  products_color = product.products_colors.last
  expect(products_color.variants.count).to eq(1)
end

