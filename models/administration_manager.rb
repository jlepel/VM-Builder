require './helpers/persistence_handler'
require './helpers/file_system_manager'

class Administration_Manager

  PATH_REGEX = /^(\/.*?\/)[^\/]*?\.\S/
  FILE_REGEX = /^\/.*?\/([^\/]*?\.\S*)/

  def initialize
    @persistence_handler = PersistenceHandler.new
    @filesystem_manager = FileSystemManager.new
  end
  
  def add_software(name, command, desc)
    @persistence_handler.add_software(name, command, desc)
  end

  # @return [string]
  def hosts?
    @persistence_handler.hosts?
  end

  # @return [string]
  def sudo?
    @persistence_handler.sudo?
  end

  # @return [string]
  def app_installpath?
    @persistence_handler.app_installpath?
  end

  # @return [string]
  def vm_installpath?
    @persistence_handler.vm_installpath?
  end

  # @return [array]
  def ansible_config?
    @persistence_handler.ansible_config?
  end


  # @return [array]
  def configuration?
    @persistence_handler.configuration?
  end

  # @return [string]
  def password?
    @persistence_handler.password?
  end

  # @return [string]
  def user?
    @persistence_handler.user?
  end

  # @return [string]
  def logfile_path?
    @persistence_handler.logfile?
  end

  def ubuntu64?
    @persistence_handler.ubuntu64?
  end

  def ubuntu32?
    @persistence_handler.ubuntu32?
  end

  def update_ansible_config(hosts, sudo)
    @persistence_handler.update_ansible_config(hosts, sudo)
  end

  def update_vagrant_config(user, password)
    @persistence_handler.update_vagrant_config(user, password)
  end

  def update_general_config(app_path, vm_path)
    @persistence_handler.update_general_config(app_path, vm_path)
  end

  def update_log_config(log)
    @persistence_handler.update_log_config(log)
  end

  def update_standardmachines(ubuntu32, ubuntu64)
    @persistence_handler.update_standardmachines_config(ubuntu32, ubuntu64)
  end

  def create_logfile(path_filename)
    if (path_filename.to_s.strip.length != 0)
      matching = path_filename.match(PATH_REGEX)
      file_path = matching.captures
      matching = path_filename.match(FILE_REGEX)
      file_name = matching.captures
      @filesystem_manager.create_folder(file_path[0].to_s)
      @filesystem_manager.create_file(file_path[0].to_s + file_name[0].to_s)
    end

  end

  def write_log(content)
  write_option = 'w'
  installpath = @persistence_handler.logfile?

  open(installpath, write_option) { |i|
    i.write(content)
  }
  end

  def log_content?
    @filesystem_manager.file_content?(@persistence_handler.logfile?)
  end

  def delete_log
    @filesystem_manager.delete_file_content(@persistence_handler.logfile?.value)
  end



end