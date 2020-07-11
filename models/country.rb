class Country
  attr_accessor :ip

  def initialize(ip)
    self.ip = ip
  end

  def geo_data
    $maxmind_reader.get(ip)
  end
end
