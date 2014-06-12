class Tax < ActiveRecord::Base
  belongs_to :state
  
  def self.update_rate!(args={})
    if args[:state_code] == "NY"
      zip_code = args.fetch(:zip_code) { raise 'Zip code not provided' }
      rate = args.fetch(:rate) { raise 'Rate not provided' }
      tax = self.where(zip_code: zip_code, state_id: State.find_by(short_name: 'NY').id).first_or_initialize
      tax.update_attributes(rate: rate)
    end
  end
end
