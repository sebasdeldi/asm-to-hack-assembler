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

  #complete 16 bits with 0self
  def self.complete_with_0(n, val)
    m = 16 - n
    complete_number = ("0"*m) + val
  end

  #check if a string is a number
  def self.is_number? string
    true if Float(string) rescue false
  end
end