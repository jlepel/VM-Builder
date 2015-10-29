require './models/machine_exporter'
require './models/machine_importer'
require './models/machine_sharing'
require './models/machine_delete'
require './helpers/persistence_handler'
require './helpers/file_system_manager'
require './models/machine_status_changer'


class MachineManager

  def initialize
    @import = Machine_Importer.new
    @export = Machine_Exporter.new
    @share = Machine_Sharing.new
    @delete = Machine_Delete.new
    @machine_status = MachineStatusChanger.new
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end


  def delete(machine_id)
    @delete.destroy_vm(machine_id)
    @delete.delete_folder(machine_id)
    @delete.delete_machine(machine_id)
  end

  def share(machine_id)
    @share.share(machine_id)
  end

  def import(machine_name, config_array)
    @import.import(machine_name, config_array)
  end

  def export(machine_id)
    @export.export(machine_id)
  end

  def get_machines(id)
    @persistence_handler.get_machine(id)
  end

  def get_machine_logfile(id)
    machine_name = @persistence_handler.get_machine(id).name
    @file_system_manager.get_file_content(@persistence_handler.get_vm_installpath + machine_name + '/' + @persistence_handler.get_machine_logfile)
  end

  def halt_machine(id)
    machine_name = @persistence_handler.get_machine(id).name
    @file_system_manager.exec(@persistence_handler.get_vm_installpath + machine_name, @machine_status.halt(machine_name))
  end

  def start_machine(id)
    machine_name = @persistence_handler.get_machine(id).name
    @file_system_manager.exec(@persistence_handler.get_vm_installpath + machine_name, @machine_status.start(machine_name))
  end

  def find_in_file(machine_name, expr)
    open(@persistence_handler.get_vm_installpath + machine_name + '/'+ @persistence_handler.get_machine_logfile).grep(/(.*)(http:.*)/)
  end


end