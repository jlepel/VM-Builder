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
    @vm_install_path = @persistence_handler.get_vm_installpath
  end

  def create_machine(machine_name, ip, description, bit, status, software, files)
    save_build(machine_name, ip, description, bit, status, software, files)
    create_folder(machine_name)

    if software.nil? && files.nil?
      create_vagrantfile(machine_name, false)
    else
      create_ansiblefile(machine_name, software, files)
      create_vagrantfile(machine_name, true)
      unless files.nil?
        upload(machine_name, files)
      end
    end

    start_vm(machine_name)
    check_build(machine_name) ? set_machine_status(machine_name, 1) : set_machine_status(machine_name, 0)

end


  def create_folder(name)
    path = @vm_install_path + name
    @file_system_manager.create_folder(path)
  end


  def create_vagrantfile(machine_name, switch)
    @vagrant_control.create_vagrant_file(machine_name, switch)
  end


  def create_ansiblefile(machine_name, software, files)
    @yaml_builder.create(machine_name, software, files)
  end


  def start_vm(machine_name)
    @file_system_manager.exec(@persistence_handler.get_vm_installpath + machine_name, @vagrant_control.startup(machine_name))
  end


  def get_softwarelist
    @persistence_handler.get_softwarelist
  end


  def get_standard_32bit_image
    @persistence_handler.ubuntu32?
  end


  def get_standard_64bit_image
    @persistence_handler.ubuntu64?
  end

  def save_build(name, ip, desc, vmimage, status, programs, files)
    @persistence_handler.save_build(name, ip, desc, vmimage, status, programs, files)
  end

  def get_machine_id(name)
    @persistence_handler.get_machine_id(name)
  end

  def check_build(machine_name)
    @vagrant_control.build_ready?(machine_name)
  end

  def set_machine_status(machine_name, status)
    @persistence_handler.set_machine_status(machine_name, status)
  end

  def upload(machine_name, files)
    @file_system_manager.upload(@vm_install_path + machine_name, files)
  end

end

