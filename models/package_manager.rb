require './helpers/persistence_handler'

class PackageManager

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def save(name, desc, selection, files)
    @persistence_handler.save_package(name, desc, selection, files)
  end

  def update(id, package_name, description, selection, files)
    @persistence_handler.update_package(id, package_name, description, selection, files)
  end

  def get_delta(id)
    @persistence_handler.get_package_delta(id)
  end

  def get_content(id)
    @persistence_handler.get_package_content(id)
  end

  def upload(file_param)
    @file_system_manager.upload(@persistence_handler.get_file_path, file_param)
  end

  def get_by_id(id)
    @persistence_handler.get_software_by_id(id)
  end

  def delete(id)
    @persistence_handler.delete_package(id)
  end




end