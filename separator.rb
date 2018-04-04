require 'pdf-reader'
require 'fileutils'

class Pdfseparator
  def initialize
    dir_path='/Users/kamlesh/Downloads/kamlesh_zip'
    extension='pdf'
    @processed_path='/Users/kamlesh/Documents/reportparser/processed'
    @dir = "#{dir_path}/*.#{extension}"
  end

  attr_reader :dir, :processed_path
  def run
    Dir.glob(dir) do |path|
      fileprocessor(path)
    end
  end

  def fileprocessor(path)
    reader = PDF::Reader.new(path)
    str = ''
    reader.pages.each do |page|
      str += page.text
    end
    #data = cleaner str
     data = str
    if data =~  /This\scases\shas\sgood\smatch\.\sYou\sprobably\swant\sto\scheck\sthis|This\sseems\sto\sbe\sa\smost\sprobable\smatch/i
      separator(path)
    else
      puts "Not found ..."
    end
  end

  def separator(file_name)
    dest = processed_path
    name = File.basename(file_name)
    puts "name => #{name}"
    if File.exist? File.expand_path file_name
      begin
      FileUtils.mv(file_name, dest)
      puts "files #{name} moved"
      rescue
        puts "Can't move .. Faces some issues "
      end
    end
  end
  def cleaner str
    str = str.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
    str = str.to_s.chomp.strip.gsub(/[^A-Za-z0-9,<\.>\/\?;:'"\[\]{}\|!@#`~$%\^\&\*\(\)\-_\=\+ \n\r\p{L}\p{M}]/i, " ").to_s.squeeze(" ").chomp.strip
    str = str.gsub(/[ á<9a><80>á <8e>â<80><80>â<80><81>â<80><82>â<80><83>â<80><84>â<80><85>â<80><86>â<80><87>â<80><88>â<80><89>â<80><8a>â<80><8b>â<80>¯â<81><9f>ã<80><80>ï»¿]+/," ")
    str.gsub!(/^:/,"")
    if str != nil
      len = str.split(" ")
      len = len.length
      cleanstr = ''
      (0..len.to_i).each do |stat|
        if str.split(" ")[stat] != nil and  str.split(" ")[stat].length > 0
          sub = str.split(" ")[stat].strip.chomp.delete(" ")
          sub = sub.squeeze(" ").chomp.strip
          cleanstr = "#{cleanstr}\s"<< sub
        end
      end
      str = cleanstr
      str = str.to_s.chomp.strip
      return str
    end
  end
end
Pdfseparator.new.run
