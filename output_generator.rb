module OutputGenerator

  def self.create_file(file_name)
    File.open(file_name.split('.')[0] + ".hack", "w+")
  end

  def self.write_in_file(file_name, content)
    File.open(file_name.split('.')[0] + ".hack", 'a') { |line|
      if !content.nil?
        line << content + "\n"
      end
    }
  end
end
