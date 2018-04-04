require 'pdf-reader'
require 'fileutils'

def execute(path)
  reader = PDF::Reader.new(path)
  str = ''
  reader.pages.each do |page|
    str += page.text
  end
  data = cleaner str
  if data =~  /This\scases\shas\sgood\smatch\.\sYou\sprobably\swant\sto\scheck\sthis|This\sseems\sto\sbe\sa\smost\sprobable\smatch/i
    separator(path)
  else
    puts "Not found ..."
  end
end

def cleaner str
  str = str.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
  str = str.to_s.chomp.strip.gsub(/[^A-Za-z0-9,<\.>\/\?;:'"\[\]{}\|!@#`~$%\^\&\*\(\)\-_\=\+ \n\r\p{L}\p{M}]/i, " ").to_s.squeeze(" ").chomp.strip
  str = str.gsub(/[ áá âââââââââââââ¯âãï»¿]+/," ").squeeze(" ").chomp.strip
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

def run
  Dir.glob("/Users/kamlesh/Downloads/kamlesh_zip/*.pdf") do |path|
    execute(path)
  end
end

def separator(file_name)
  dest = '/Users/kamlesh/Documents/reportparser/processed'
  name = File.basename(file_name)
  puts "name => #{name}"
  if File.exist? File.expand_path file_name
    #begin
      FileUtils.mv(file_name, dest)
      puts "files #{name} moved"
    #rescue
    #  puts "Can't move .. Faces some issues "
    #end
  end
end
run
