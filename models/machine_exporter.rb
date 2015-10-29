require './helpers/vagrant_control'
require './helpers/persistence_handler'
require './helpers/file_system_manager'


class Machine_Exporter

  def initialize
    @vagrant = VagrantControl.new
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def export(machine_id)
    machine_name = @persistence_handler.get_machine(machine_id).name
    @file_system_manager.exec(@persistence_handler.get_vm_installpath + machine_name, @vagrant.export(machine_name))
  end



end