require './helpers/persistence_handler'
class Software_Editor

  def initialize
    @persistence_handler = PersistenceHandler.new
  end

  def get_software
    @persistence_handler.all_software?
  end

  def save_build(program, command, desc, selection, file, destination)
    @persistence_handler.save_software_build(program, command, desc, selection, file, destination)
  end

  def save_file(file)

  end



end