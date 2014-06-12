require 'spec_helper'

describe FileParser do
  describe ".update_tax_rates" do
    context 'when the argument is a tax file' do
      it 'updates tax rates' do
        tax_rates_file = File.join(Rails.root, 'spec', 'support', 'tax_rates.txt')
        
        tax1 = FactoryGirl.create(:tax, rate: 0.99, zip_code: "10024")
        tax2 = FactoryGirl.create(:tax, rate: 1.23, zip_code: "94702")
        
        Tax.should_receive(:update_rate!).twice
        FileParser.update_tax_rates(tax_rates_file)
      end
    end
  end
end
