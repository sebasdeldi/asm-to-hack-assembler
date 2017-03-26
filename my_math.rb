module MyMath
  #converts decimal to binary
  def self.to_binary(n)
    n = n.to_i
    if n >= 0
      n.to_s(2)
    else
      16.downto(0).map { |b| n[b] }.join
    end
  end
end