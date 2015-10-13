require './helpers/persistence_handler'
require './helpers/file_system_manager'
require './helpers/vagrant_control'

class VMBuilder

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
    @vagrant_control = VagrantControl.new
  end

  def add_machine(name, desc, status)
    @persistence_handler.add_machine(name, desc, status)
  end

  def get_all_machines
    @persistence_handler.get_all_machines
  end

  def get_machine(id)
    @persistence_handler.get_machine(id)
  end



end