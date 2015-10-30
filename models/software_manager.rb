require './helpers/persistence_handler'
require './helpers/file_system_manager'
class SoftwareManager

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def delete(id)
    @persistence_handler.delete_software(id)
  end


  def add(name, command, desc)
    @persistence_handler.add_software(name, command, desc)
  end

  def update(id, program, command, description)
    @persistence_handler.update_software(id, program, command, description)
  end
  def get_all
    @persistence_handler.get_softwarelist
  end

  def get_by_id(id)
    @persistence_handler.get_software_by_id(id)
  end

end