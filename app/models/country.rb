class Country
  attr_accessor :ip

  def initialize(ip)
    self.ip = ip
  end

  def geo_data
    reader = MaxMind::DB.new(
      Rails.root.to_s + '/db/GeoLite2-Country.mmdb',
      mode: MaxMind::DB::MODE_MEMORY
    )
    
    country = reader.get(ip)

    reader.close

    country
  end
end
