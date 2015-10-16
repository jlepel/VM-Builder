require 'fileutils'

class FileSystemManager

  def create_folder(folder_name)
    unless File.directory?(folder_name)
      FileUtils.mkdir_p folder_name, :verbose => true
    end
  end

  def delete_folder(path)
    FileUtils.rm_rf(path)
  end

  def create_file(file_name)
    FileUtils.touch(file_name)
  end

  def get_file_content(file_name)
    file = File.open(file_name, 'rb')
    content = file.read
    file.close
    content
  end

  def exec(path, command)
    if File.directory?(path)
      FileUtils.cd(path) do
        system(command)
      end
    end
  end

  def delete_file_content(path)
    File.open(path, 'w') {|f| f.truncate(0) }
  end

  def copy_to(file, from, target)
    FileUtils.move from + file, target
  end

  def move_to(file, from, target)
    FileUtils.move from + file, target
  end

  def upload(path, file_param)
    file_param.each do |file_data|
      File.open(path + file_data[:file][:filename], 'w') do |f|
       # File.open('uploads/' + file_data[:file][:filename], "w") do |f|
        f.write(file_data[:file][:tempfile].read)
      end
    end
  end

end