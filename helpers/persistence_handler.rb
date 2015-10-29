require 'data_mapper'
require 'dm-transactions'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/builder.db")
#DataMapper::setup(:default, 'mysql://root:schinken@localhost/vmb')

class Machine
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :name, String, :length => 255, :required => true # A varchar type string, for short strings
  property :ip, String, :length => 15
  property :description, String, :length => 255# A text block, for longer string data.
  property :status, Integer # An auto-increment integer key

  has n, :machinefiles
  has n, :datafiles, :through => :machinefiles


  has n, :machinesoftwares
  has n, :softwares, :through => :machinesoftwares
  belongs_to :vmimage
end

class Machinesoftware
  include DataMapper::Resource

  belongs_to :machine, :key => true
  belongs_to :software, :key => true
end

class Machinefile
  include DataMapper::Resource

  belongs_to :machine, :key => true
  belongs_to :datafile, :key => true
end

class Software
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :name, String, :length => 255, :required => true # A varchar type string, for short strings
  property :command, String, :length => 255 # A text block, for longer string data.
  property :description, String, :length => 255 # A text block, for longer string data.
  property :package, Integer, :required => true


  has n, :softwarefiles
  has n, :datafiles, :through => :softwarefiles

  has n, :machinesoftwares
  has n, :machines, :through => :machinesoftwares

  has n, :packages, :child_key => [ :source_id ]
  has n, :parts, self, :through => :packages, :via => :sub
end

class Package
  include DataMapper::Resource

  belongs_to :source, 'Software', :key => true
  belongs_to :sub, 'Software', :key => true

end

class Softwarefile
  include DataMapper::Resource

  belongs_to :software, :key => true
  belongs_to :datafile, :key => true

end

class Vmimage
  include DataMapper::Resource

  property :vm_name, String, :length => 255, :required => true, :key => true # A varchar type string, for short strings
  property :url, String, :length => 255, :required => true # A text block, for longer string data.

  has n, :machines
end

class Datafile
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :name, String, :length => 255, :required => true # A varchar type string, for short strings
  property :source, String, :length => 255, :required => true # A text block, for longer string data.
  property :target, String, :length => 255, :required => true # A text block, for longer string data.

  has n, :fileoptions
  has n, :options, :through => :fileoptions

  has n, :machinefiles
  has n, :machines, :through => :machinefiles

  has n, :softwarefiles
  has n, :softwares, :through => :softwarefiles

end

class Option
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :option, String, :length => 255, :required => true # A varchar type string, for short strings

  has n, :fileoptions
  has n, :datafiles, :through => :fileoptions
end

class Fileoption
  include DataMapper::Resource

  belongs_to :datafile, :key => true
  belongs_to :option, :key => true
end


class Configuration
  include DataMapper::Resource
  property :config_option, String, :length => 255, :required => true, :key => true# A varchar type string, for short strings
  property :value, String, :length => 255, :required => true # A varchar type string, for short strings
end

DataMapper.finalize.auto_upgrade!

class PersistenceHandler



  def save_build(name, ip, desc, vmimage, status, programs)
    Machine.transaction do |t|
      begin
        Machine.first_or_create(:name => name, :ip => ip, :description => desc, :vmimage_vm_name => vmimage, :status => status)
          if (!programs.nil?)
            programs.each do |software|
              Machinesoftware.first_or_create(:machine_id => get_machine_id(name), :software_id => get_software_id(software))
            end
          end
      rescue
        t.rollback
      end
    end
  end



  def get_software_by_name(name)
    Software.first(:name => name)
  end

  def get_software_by_id(id)
    Software.first(:id => id)
  end

  def update_software(id, name, command, description)
    Software.first(:id => id).update(:name => name, :command => command, :description => description)
  end

  def get_machine_image(machine_name)
    image = Machine.first(:name => machine_name).vmimage_vm_name
    Vmimage.first(:vm_name => image)
  end

  def get_all_machines
    Machine.all
  end

  def get_machine_id(machine_name)
    Machine.first(:name => machine_name).id
  end


  def get_machine_ip(machine_name)
    machine_id = Machine.first(:name => machine_name)
    machine_id.ip
  end


  def delete_machine(id)
    machinesoftware = Machinesoftware.all(:machine_id => id)
    machinesoftware.each do |ms|
      ms.destroy
    end
    Machine.get(id).destroy
  end

  def get_machine(id)
    Machine.get(id)
  end

  def get_softwarelist
    Software.all
  end

  def software_file_bundle(name, command, desc, file_array)
    Software.transaction do |t|
      begin
        Software.create(:name => name, :command => command, :description => desc)
        file_array.each do |file_data|
          Datafile.create(:name => file_data[:file][:filename], :source => self.get_upload_folder, :target => file_data[:path])
          Softwarefile.first_or_create(:software_id => get_software_id(name), :datafile_id => get_file_id(file_data[:file][:filename]))
        end
      rescue
        t.rollback
      end
    end
  end

  def update_package(id, package_name, description, selection, files)
    Software.first(:id => id).update(:name => package_name, :description => description)
    selection.each do |software|
      Package.update(:source_id => id, :sub_id => get_software_id(software))
    end
  end


  def get_package_content(id)
    @content_array = Array.new
    Package.all(:source_id => id).each do |content|
      @content_array <<  Software.first(:id => content.sub_id).name
    end
    @content_array
  end

  def get_package_delta(id)
    software_array = Array.new
    Software.all.each do | elem |
      software_array << elem.name
    end

    Package.all(:source_id => id).each do |elem|
      software_array.delete(Software.first(:id => elem.sub_id).name)
    end
    software_array
  end

  def get_all_packages_by_id(id)
    Package.all(:source_id => id)
  end

  def find_package(software_id)
    Package.first(:source_id => software_id)
  end

  def get_file_id(file_name)
    Datafile.first(:name =>file_name).id
  end

  def get_software_id(software_name)
    Software.first(:name => software_name).id
  end

  def get_hosts
    Configuration.first(:config_option => 'hosts').value
  end

  def sudo?
    Configuration.first(:config_option => 'sudo').value
  end

  def update_ansible_config(hosts, sudo)
    get_hosts.update(:value => hosts)
    sudo?.update(:value => sudo)
  end

  def set_machine_status(machine_name, status)
    Machine.first(:name => machine_name).update(:status => status)
  end

  def get_cloud_user
    Configuration.first(:config_option => 'cloud_user').value
  end

  def get_cloud_password
    Configuration.first(:config_option => 'cloud_pw').value
  end

  def get_upload_folder
    Configuration.first(:config_option => 'upload_folder').value
  end

  def update_vagrant_config(user, password)
    get_cloud_user.update(:value => user)
    get_cloud_password.update(:value => password)
  end


  def get_configurations
    Configuration.all
  end

  def get_machine_logfile
    Configuration.first(:config_option => 'machine_logfile_name').value
  end


  def get_vagrant_hosts
    Configuration.first(:config_option => 'hosts').value
  end

  def vagrant_sudo?
    Configuration.first(:config_option => 'sudo').value
  end

  def get_app_installpath
    Configuration.first(:config_option => 'app_installpath').value
  end

  def get_vm_installpath
    Configuration.first(:config_option => 'vm_installpath').value
  end

  def update_general_config(app_path, vm_path)
    Configuration.first(:config_option => 'app_installpath').update(:value => app_path)
    Configuration.first(:config_option => 'vm_installpath').update(:value => vm_path)
  end

  def update_log_config(log)
    Configuration.first(:config_option => 'logfile').update(:value => log)
  end

  def get_logfile_path
    Configuration.first(:config_option => 'logfile').value
  end

  def get_file_path
    Configuration.first(:config_option => 'file_path').value
  end

  def file_id?(file)
    Datafile.first(:name => file).id
  end


  def ubuntu64?
    Vmimage.first(:vm_name => 'precise64')
  end


  def ubuntu32?
    Vmimage.first(:vm_name => 'precise32')
  end

  def update_standardmachines(ubuntu32, ubuntu64)
    ubuntu32?.update(:value => ubuntu32)
    ubuntu64?.update(:value => ubuntu64)
  end

  def save_import(machine_name)
    Machine.create(:name => machine_name, :ip => 'import', :description => 'import', :status => 1, :vmimage_vm_name => 'precise32')
  end

  def save_software_build(program, command, desc, selection, file)
    Software.transaction do |t|
      begin
        Software.first_or_create(:name => program, :command => command, :description => desc, :package => 1)

        selection.each do |software|
          Package.first_or_create(:source_id => get_software_id(program), :sub_id => get_software_id(software))
        end

        file.each do |file_data|
          Datafile.first_or_create(:name => file_data[:file][:filename], :source => get_file_path,  :target => file_data[:path])
          Softwarefile.first_or_create(:software_id => get_software_id(program), :datafile_id => file_id?(file_data[:file][:filename]))
        end
      rescue
        t.rollback
      end

    end
  end

  def save_software(program, command, desc)
    Software.first_or_create(:name => program, :command => command, :description => desc, :package => 0)
  end

  def save_software_package(program, command, desc, selection)
    Software.transaction do |t|
      begin
        Software.first_or_create(:name => program, :command => command, :description => desc, :package => 1)
        selection.each do |software|
          Package.first_or_create(:source_id => get_software_id(program), :sub_id => get_software_id(software))
        end
      rescue
        t.rollback
      end
    end
  end

end
