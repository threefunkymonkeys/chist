class Hash
  def strip
    puts self
    self.inject({}) { |res, (key, value)| res[key] = value.strip; res}
  end
end
