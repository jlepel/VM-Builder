require './helpers/vagrant_control'
require './models/buildprocessor'
require './helpers/file_system_manager'
require './helpers/persistence_handler'
class Machine_Importer

  def initialize
    @vagrant = VagrantControl.new
    @buildprocessor = Buildprocessor.new
    @file_system_manager = FileSystemManager.new
    @persistence_handler = PersistenceHandler.new
  end

  def import(machine_name, config_array)
    machine_path = @persistence_handler.get_vm_installpath + machine_name +'/'
    @file_system_manager.create_folder(machine_path)
    upload(machine_path, config_array)
    save_import(machine_name)
    #@buildprocessor.start_vm(machine_name)

  end

  def upload(file_path, file_array)
    @file_system_manager.upload(file_path, file_array)
  end

  def save_import(machine_name)
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/'

    @persistence_handler.save_import(machine_name)
    @file_system_manager.exec(machine_log_path, 'echo \'import from ' + machine_name + ' completed\' >> '  + @persistence_handler.get_machine_logfile)
  end

end