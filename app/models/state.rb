class State < ActiveRecord::Base
  has_many :addresses
  
  validates_uniqueness_of :short_name
  
  def self.new_york
    find_by(short_name: 'NY')
  end
end
