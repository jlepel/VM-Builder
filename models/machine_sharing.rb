require './helpers/vagrant_control'
require './helpers/persistence_handler'
class Machine_Sharing

  def initialize
    @vagrant = VagrantControl.new
    @persistence_handler = PersistenceHandler.new
  end

  def share(machine_id)
    machine = @persistence_handler.machine?(machine_id).name
    @file_system_manager.exec(@persistence_handler.vm_installpath?.value + machine, @vagrant_control.share_command?)
  end



end