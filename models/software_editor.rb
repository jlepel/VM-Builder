require './helpers/persistence_handler'
require './helpers/file_system_manager'
class Software_Editor

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def update_package(id, package_name, description, selection, files)
     @persistence_handler.update_package(id, package_name, description, selection, files)
  end

  def get_bundle_delta(id)
    @persistence_handler.get_package_delta(id)
  end

  def get_bundle_content(id)
    @persistence_handler.get_package_content(id)
  end

  def upload(file_param)
    @file_system_manager.upload(@persistence_handler.get_file_path, file_param)
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
    @persistence_handler.get_software_by_id(id)
  end

  def save_build(program, command, desc, selection, file)

    if selection.nil? && ((file.nil? || file == 0))
      puts 'nur program'
      @persistence_handler.save_software(program, command, desc)
    end

    unless selection.nil? && file.nil?
      puts 'prog + selection'
      @persistence_handler.save_software_package(program, command, desc, selection)
    end

    unless selection.nil? && !file.nil?
      puts 'prog + selection + file'
      @persistence_handler.save_software_build(program, command, desc, selection, file)
    end

    if selection.nil? && !file.nil?
      puts 'prog + file'
    end
  end

  def save_file(name, source, target)
    
  end



end