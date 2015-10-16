require './helpers/persistence_handler'
require './helpers/file_system_manager'

class Administration_Manager

  PATH_REGEX = /^(\/.*?\/)[^\/]*?\.\S/
  FILE_REGEX = /^\/.*?\/([^\/]*?\.\S*)/

  def initialize
    @persistence_handler = PersistenceHandler.new
    @filesystem_manager = FileSystemManager.new
  end

  def get_machine_logfile
    @persistence_handler.get_machine_logfile
  end

  # @return [string]
  def get_hosts
    @persistence_handler.get_hosts
  end

  # @return [string]
  def sudo?
    @persistence_handler.sudo?
  end

  def get_upload_folder
    @persistence_handler.get_upload_folder
  end

  # @return [string]
  def get_app_installpath
    @persistence_handler.get_app_installpath
  end

  # @return [string]
  def get_vm_installpath
    @persistence_handler.get_vm_installpath
  end

  # @return [array]
  def get_ansible_config
    @persistence_handler.get_ansible_config
  end


  # @return [array]
  def configuration?
    @persistence_handler.get_configurations
  end

  # @return [string]
  def password?
    @persistence_handler.get_cloud_password
  end

  # @return [string]
  def user?
    @persistence_handler.get_cloud_user
  end

  # @return [string]
  def get_logfile_path
    @persistence_handler.get_logfile_path
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
  installpath = @persistence_handler.get_logfile_path

  open(installpath, write_option) { |i|
    i.write(content)
  }
  end

  def get_applicationlog_content
    @filesystem_manager.get_file_content(@persistence_handler.get_logfile_path)
  end

  def delete_log
    @filesystem_manager.delete_file_content(@persistence_handler.get_logfile_path.value)
  end



end