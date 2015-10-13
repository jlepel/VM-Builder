require './helpers/vagrant_control'
require './helpers/persistence_handler'
require './helpers/file_system_manager'
class Machine_Sharing

  def initialize
    @vagrant = VagrantControl.new
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def share(machine_id)
    puts @persistence_handler.get_vm_installpath
    #machine = @persistence_handler.get_machine(machine_id).name
    #@file_system_manager.exec(@persistence_handler.get_vm_installpath.value + machine, @vagrant.share)
  end



end