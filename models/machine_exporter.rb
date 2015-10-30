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
    machine_path = @persistence_handler.get_vm_installpath + machine_name + '/'
    @file_system_manager.exec(machine_path, @vagrant.export(machine_name))
    @file_system_manager.exec(machine_path, 'tar -czf '+ machine_name+'.tar.gz *')
  end



end