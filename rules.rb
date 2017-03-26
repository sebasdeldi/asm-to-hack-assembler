require "./my_math.rb"
class Rules
  JUMP_ARR = [";JGT", ";JEQ", ";JGE", ";JLT", ";JNE", ";JLE", ";JMP"]

  @stored_variables = []
  @stored_variables_value = []
  @counter = 0

  #----------------------------------------------------------A-INSTRUCTIONS-CODE----------------------------------------------------------
  # A instructions have to be 16 bit long
  def self.a_16_bit (line)
    a_rules = Rules.new
    #if is one of the reserved variables
    if line[1] == 'R' || line[1..line.length] == "SP" || line[1..line.length] == "ARG" ||  line[1..line.length] == "KBD" ||  line[1..line.length] == "SCREEN" ||  line[1..line.length] == "THIS" || line[1..line.length] == "THAT" || line[1..line.length] == "LCL"
      bin_val = a_rules.set_reserved_variable_value(line)
    elsif (/^[[:alpha:]]+$/).match(line[1..line.length]) # If is a user created variable
      # Code for handling variables used more than once throughout the program
      unless @stored_variables.include?(line[1..line.length]) #If varible not stored => store it
        @stored_variables << line[1..line.length]
        @counter += 1 # so new variables get the next memory position
      end
      bin_val_to_array = MyMath.to_binary(15 + @counter)
      @stored_variables_value << bin_val_to_array # Store variable value in this array
      if @stored_variables.last !=  (line[1..line.length]) # If the last stored variable isn't the current variable is because it was previously stored and already has a value
        bin_val = @stored_variables_value[@stored_variables.index(line[1..line.length])] # Each variable is stored at the same position as it's value => Get that value from the value's array
      else
        bin_val = MyMath.to_binary(15 + @counter) # New variable => give new value to it
      end
    else
      bin_val = MyMath.to_binary(line[1..line.length]) # If is a regular @[(0-9)*] expression
    end
    n = bin_val.to_s.length
    m = 16 - n
    complete_number = ("0"*m) + bin_val.to_s # Complete 16 bits with 0's
  end


  def set_reserved_variable_value(line)
    if line[1..line.length] == "R0"
      bin_val = MyMath.to_binary(0)
    elsif line[1..line.length] == "R1"
      bin_val = MyMath.to_binary(1)
    elsif line[1..line.length] == "R2"
      bin_val = MyMath.to_binary(2)
    elsif line[1..line.length] == "R3"
      bin_val = MyMath.to_binary(3)
    elsif line[1..line.length] == "R4"
      bin_val = MyMath.to_binary(4)
    elsif line[1..line.length] == "R5"
      bin_val = MyMath.to_binary(5)
    elsif line[1..line.length] == "R6"
      bin_val = MyMath.to_binary(6)
    elsif line[1..line.length] == "R7"
      bin_val = MyMath.to_binary(7)
    elsif line[1..line.length] == "R8"
      bin_val = MyMath.to_binary(8)
    elsif line[1..line.length] == "R9"
      bin_val = MyMath.to_binary(9)
    elsif line[1..line.length] == "R10"
      bin_val = MyMath.to_binary(10)
    elsif line[1..line.length] == "R11"
      bin_val = MyMath.to_binary(11)
    elsif line[1..line.length] == "R12"
      bin_val = MyMath.to_binary(12)
    elsif line[1..line.length] == "R13"
      bin_val = MyMath.to_binary(13)
    elsif line[1..line.length] == "R14"
      bin_val = MyMath.to_binary(14)
    elsif line[1..line.length] == "R15"
      bin_val = MyMath.to_binary(15)
    elsif line[1..line.length] == "SP"
      bin_val = MyMath.to_binary(0)
    elsif line[1..line.length] == "LCL"
      bin_val = MyMath.to_binary(1)
    elsif line[1..line.length] == "ARG"
      bin_val = MyMath.to_binary(2)
    elsif line[1..line.length] == "THIS"
      bin_val = MyMath.to_binary(3)
    elsif line[1..line.length] == "THAT"
      bin_val = MyMath.to_binary(4)
    elsif line[1..line.length] == "SCREEN"
      bin_val = MyMath.to_binary(16384)
    elsif line[1..line.length] == "KBD"
      bin_val = MyMath.to_binary(24576)
    end
  end

  #----------------------------------------------------------C-INSTRUCTIONS-CODE----------------------------------------------------------

  # Completes de 16 bits of the c instructions
  def self.c_16_bit(line)
    c_rule = Rules.new #instance for calling the private methods used for c_16_bit
    "111" + c_rule.add_comp(line) + c_rule.add_dest(line) + c_rule.add_jump(line)
  end

  # adds comp section to C instructions
  def add_comp(line)
    if line[0..1] == "M;" || line.split("=")[1] == "M" || line == "M"
      "1110000"
    elsif line[0..1] == "D;" || line.split("=")[1] == "D" || line == "D"
      "0001100"
    elsif line[0..1] == "A;" || line.split("=")[1] == "A" || line == "A"
      "0110000"
    elsif line[0..1] == "1;" || line.split("=")[1] =="1" || line == "1"
      "0111111"
    elsif line[0..1] == "0;" || line.split("=")[1] == "0" || line == "0"
      "0101010"
    elsif line[0..2] == "-1;" || line.split("=")[1] == "-1" || line == "-1"
      "0111010"
    elsif line[0..2] == "-M;" || line.split("=")[1] == "-M" || line == "-M"
      "1110011"
    elsif line[0..2] == "-A;" || line.split("=")[1] =="-A" || line == "-A"
      "0110011"
    elsif line[0..2] == "-D;" || line.split("=")[1] =="-D" || line == "-D"
      "0001111"
    elsif line[0..2] == "!A;" || line.split("=")[1] =="!A" || line == "!A"
      "0110001"
    elsif line[0..2] == "!D;" || line.split("=")[1] =="!D" || line == "!D"
      "0001101"
    elsif line[0..2] == "!M;" || line.split("=")[1] =="!M" || line == "!M"
      "1110001"
    elsif line[0..3] == "M+1;" || line.split("=")[1] =="M+1" || line == "M+1"
      "1110111"
    elsif line[0..3] == "A+1;" || line.split("=")[1] =="A+1" || line == "A+1"
      "0110111"
    elsif line[0..3] == "D+1;" || line.split("=")[1] =="D+1" || line == "D+1"
      "0011111"
    elsif line[0..3] == "M-1;" || line.split("=")[1] =="M-1" || line == "M-1"
      "1110010"
    elsif line[0..3] == "D-1;" || line.split("=")[1] =="D-1" || line == "D-1"
      "0001110"
    elsif line[0..3] == "A-1;" || line.split("=")[1] =="A-1" || line == "A-1"
      "0110010"
    elsif line[0..3] == "D+A;" || line.split("=")[1] == "D+A" || line == "D+A"
      "0000010"
    elsif line[0..3] == "D+M;" || line.split("=")[1] =="D+M" || line == "D+M"
      "1000010"
    elsif line[0..3] == "D-A;" || line.split("=")[1] =="D-A" || line == "D-A"
      "0010011"
    elsif line[0..3] == "D-M;" || line.split("=")[1] =="D-M" || line == "D-M"
      "1010011"
    elsif line[0..3] == "A-D;" || line.split("=")[1] =="A-D" || line == "A-D"
      "0000111"
    elsif line[0..3] == "M-D;" || line.split("=")[1] =="M-D" || line == "M-D"
      "1000111"
    elsif line[0..3] == "D&A;" || line.split("=")[1] =="D&A" || line == "D&A"
      "0000000"
    elsif line[0..3] == "D&M;" || line.split("=")[1] =="D&M" || line == "D&M"
      "1000000"
    elsif line[0..3] == "D|A;" || line.split("=")[1] =="D|A" || line == "D|A"
      "0010101"
    elsif line[0..3] == "D|M;" || line.split("=")[1] =="D|M" || line == "D|M"
      "1010101"
    else
      "comp_error"
    end
  end

  # adds dest section to C instructions
  def add_dest(line)
    if line[0..1] == "M="
      "001"
    elsif line[0..1] == "D="
      "010"
    elsif line[0..1] == "A="
      "100"
    elsif line[0..2] == "MD="
      "011"
    elsif line[0..2] == "AM="
      "101"
    elsif line[0..2] == "AD="
      "110"
    elsif line[0..3] == "AMD="
      "111"
    elsif ((line.split("=").first != 'M' || line.split("=").first != 'D' || line.split("=").first != 'A' || line.split("=").first != 'MD' || line.split("=").first != 'AM' || line.split("=").first != 'AD' || line.split("=").first != 'AMD' ) )
      if line.split("=").first == line
        "000"
      else
        "dest_error"
      end
    else
      "000"
    end
  end

  # adds jump section to C instructions
  def add_jump(line)
    if line.length >= 5 && line.include?(";")
      jump_instruction = line[line.length-4..line.length]
      if JUMP_ARR.include? jump_instruction
        if JUMP_ARR.index(jump_instruction) == 0
          "001"
        elsif JUMP_ARR.index(jump_instruction) == 1
          "010"
        elsif JUMP_ARR.index(jump_instruction) == 2
          "011"
        elsif JUMP_ARR.index(jump_instruction) == 3
          "100"
        elsif JUMP_ARR.index(jump_instruction) == 4
          "101"
        elsif JUMP_ARR.index(jump_instruction) == 5
          "110"
        elsif JUMP_ARR.index(jump_instruction) == 6
          "111"
        end
      else
        if !JUMP_ARR.include? (line.split(";")[1])
          "jump_error"
        else
          "000"
        end
      end
    else
      "000"
    end
  end

end