require './helpers/persistence_handler'

class VMBuilder

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
    @vagrant_control = VagrantControl.new
  end

  def get_all_machines
    @persistence_handler.get_all_machines
  end

end