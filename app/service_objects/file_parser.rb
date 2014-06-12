require 'csv'
class FileParser
  
  def self.update_tax_rates(file)
    CSV.open(file).each do |line|
      state_code = line[0]
      zip_code = line[-3]
      new_tax_rate = line[-9]
      Tax.update_rate!(state_code: state_code, zip_code: zip_code, rate: new_tax_rate)
    end
  end
  
end
