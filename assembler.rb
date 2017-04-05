require "./analizer.rb"
require "./output_generator.rb"
require "./my_math.rb"

class Assembler
  #reads the input file and generates the traduced output file
  def traduce(file)
    @stored_labels_value = []
    @deleted_lines_count  = 0

    OutputGenerator.create_file(file) # creates output file
    File.foreach(file).with_index do |line, line_num|
      if line.include? '/'
        line = line.gsub(/\s+/, "").split('/')[0]  #removing comments and whitespaces
        @deleted_lines_count += 1
      else
        if line.include? '('
          @deleted_lines_count += 1
          @stored_labels_value << MyMath.complete_with_0(MyMath.to_binary(line_num - @deleted_lines_count-1).length, MyMath.to_binary(line_num - @deleted_lines_count-1)) + " " + line.gsub(/[()]/, "")
        end
        line = line.gsub(/\s+/, "").split('(')[0]  #removing labels and whitespaces
      end
      if !line.nil? #so i can skip blank lines
        line_result = Analizer.analize(line, @stored_labels_value)
      end

      error?(line, line_num + 1, line_result)
      OutputGenerator.write_in_file(file, line_result)
    end
  end

  def error?(line, line_num , line_result)
    if !line_result.nil?
      if line_result.include? "dest_error"
        raise "ERROR AT LINE: " + line + " COLUMN: " + line_num.to_s + " PLEASE CHECK THE DESTINATION PART OF THIS LINE"
      elsif line_result.include? "jump_error"
        raise "ERROR AT LINE: " + line + " COLUMN: " + line_num.to_s + " PLEASE CHECK THE JUMP PART OF THIS LINE"
      elsif line_result.include? "comp_error"
        raise "ERROR AT LINE: " + line + " COLUMN: " + line_num.to_s + " PLEASE CHECK THE COMP PART OF THIS LINE"
      end
    end
  end

end



assembler = Assembler.new
puts assembler.traduce(ARGV.first)
