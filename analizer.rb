require "./rules.rb"

module Analizer
  def self.analize(line, label_values = nil)
    if line[0] == '@' # is instruction A
      Rules.a_16_bit(line, label_values)
    else  # is instruction C
      if !line.empty?
        Rules.c_16_bit(line)
      end
    end
  end
end