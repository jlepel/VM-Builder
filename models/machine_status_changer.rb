require './helpers/vagrant_control'
require './helpers/persistence_handler'
class MachineStatusChanger

  def initialize
    @vagrant = VagrantControl.new
    @persistence_handler = PersistenceHandler.new
  end


  def start(machine_name)
    @vagrant.startup(machine_name)
    @persistence_handler.set_machine_status(machine_name, 1)
  end

  def halt(machine_name)
    @vagrant.halt(machine_name)
    @persistence_handler.set_machine_status(machine_name, 0)
  end

end