class Redis

  def self.connect(url)
    @url = url
    self.client
  end

  def self.client
    @client ||= Redic.new(@url)
  end
end
