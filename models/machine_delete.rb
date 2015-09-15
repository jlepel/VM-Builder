require './helpers/persistence_handler'
require './helpers/file_system_manager'
require './helpers/vagrant_control'

class Machine_Delete

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
    @vagrant_control = VagrantControl.new
  end


  def delete_folder(machine_id)
    machine = @persistence_handler.machine?(machine_id).name
    machine_folder = @persistence_handler.vm_installpath?.value + machine
    @file_system_manager.delete_folder(machine_folder)
  end

  def destroy_vm(machine_id)
    machine = @persistence_handler.machine?(machine_id).name
    @file_system_manager.exec(@persistence_handler.vm_installpath?.value + machine, @vagrant_control.destroy_command?)
  end

  def delete_machine(id)
    @persistence_handler.delete_machine(id)
  end


end