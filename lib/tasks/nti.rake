namespace :nti do
  
  desc "Create admin nettheory user"
  task(:create_admin_user => :environment) do
    unless User.exists?(email: "admin@nettheory.com")
      user = User.new
      user.email = "admin@nettheory.com"
      user.password = "test123"
      user.password_confirmation = "test123"
      user.roles << Role.find_or_create_by(name: 'admin')
      user.save!
    end
  end
  
  task(:create_sizes => :environment) do
    ["XS","S", "M", "L", "XL", "One Size"].each_with_index do |size_name, index|
      size = Size.where(name: size_name).first_or_initialize
      size.sort_order = index
      size.save
    end
  end
  
  task(:create_categories => :environment) do
    ["Eyeglasses", "Sunglasses"].each do |category_name|
      Category.create(name: category_name) unless Category.exists?(name: category_name)
    end
  end
  
end