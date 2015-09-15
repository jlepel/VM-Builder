require './helpers/persistence_handler'
require './helpers/vagrant_control'
require './helpers/file_system_manager'
require './helpers/yaml_builder'

class Buildprocessor

  def initialize
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
    @yaml_builder = Yaml_Builder.new
    @vagrant_control = VagrantControl.new
    @vm_install_path = @persistence_handler.vm_installpath?.value
  end


  def create_folder(name)
    path = @vm_install_path + name
    @file_system_manager.create_folder(path)
  end

  def create_vagrantfile(machine_name)
    @vagrant_control.create_file(machine_name)
  end

  def create_ansiblefile(machine_name, software)
    @yaml_builder.create(machine_name, software)
  end

  def start_vm(machine_name)
    @file_system_manager.exec(@persistence_handler.vm_installpath?.value + machine_name, @vagrant_control.startup_command?)
  end


  def get_software
    @persistence_handler.all_software?
  end

  def standard_32bit?
    @persistence_handler.ubuntu32?
  end

  def standard_64bit?
    @persistence_handler.ubuntu64?
  end

  def save_build(name, ip, desc, vmimage, status, programs)
    @persistence_handler.save_build(name, ip, desc, vmimage, status, programs)
  end

  def machine?(name)
    @persistence_handler.machine_id?(name)
  end


end

