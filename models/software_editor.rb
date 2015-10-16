require './helpers/persistence_handler'
require './helpers/file_system_manager'
class Software_Editor

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def upload(file_param)
    @file_system_manager.upload(file_param)
  end

  def add_software_file_bundle(name, command, desc, file_array)
    @persistence_handler.software_file_bundle(name, command, desc, file_array)
  end

  def add_software(name, command, desc)
    @persistence_handler.add_software(name, command, desc)
  end

  def update_software(id, program, command, description)
    @persistence_handler.update_software(id, program, command, description)
  end
  def get_softwarelist
    @persistence_handler.get_softwarelist
  end

  def get_software(id)
    @persistence_handler.get_software(id)
  end

  def save_build(program, command, desc, selection, file, destination)

    if selection.nil? && ((file.nil? || file == 0))
      puts 'nur program'
      @persistence_handler.save_software(program, command, desc)
    end

    if !selection.nil? && file.nil?
      puts 'prog + selection'
      @persistence_handler.save_software_bundle(program, command, desc, selection)
    end

    if !selection.nil? && !file.nil?
      puts 'prog + selection + file'
      @persistence_handler.save_software_build(program, command, desc, selection, file, destination)
    end

    if selection.nil? && !file.nil?
      puts 'prog + file'
    end







  end

  def save_file(name, source, target)
    
  end



end