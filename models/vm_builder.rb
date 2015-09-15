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

  def machines?
    @persistence_handler.all_machines?
  end

  def machine?(id)
    @persistence_handler.machine?(id)
  end



end