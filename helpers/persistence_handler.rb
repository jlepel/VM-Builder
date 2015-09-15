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
  property :command, String, :length => 255, :required => true # A text block, for longer string data.
  property :description, String, :length => 255 # A text block, for longer string data.


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
        programs.each do |software|
          Machinesoftware.first_or_create(:machine_id => machine_id?(name), :software_id => software_id?(software))
        end
      rescue
        t.rollback
      end
    end
  end

  def machine_image?(machine_name)
    machine = Machine.first(:name => machine_name)
    image = machine.vmimage_vm_name
    Vmimage.first(:vm_name => image)

  end

  def all_machines?
    Machine.all
  end

  def machine_id?(machine_name)
    machine_id = Machine.first(:name => machine_name)
    machine_id.id
  end

  def machine?(id)
    Machine.get(id)
  end

  def machine_ip?(machine_name)
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


  def all_software?
    Software.all
  end

  def add_software(name, command, desc)
    Software.first_or_create(:name => name, :command => command, :desc => desc)
  end

  def software_id?(software_name)
    software_id = Software.first(:name => software_name)
    software_id.id
  end

  def hosts?
    Configuration.first(:config_option => 'hosts')
  end

  def sudo?
    Configuration.first(:config_option => 'sudo')
  end

  def update_ansible_config(hosts, sudo)
    hosts?.update(:value => hosts)
    sudo?.update(:value => sudo)
  end


  def user?
    Configuration.first(:config_option => 'cloud_user')
  end

  def password?
    Configuration.first(:config_option => 'cloud_pw')
  end

  def update_vagrant_config(user, password)
    user?.update(:value => user)
    password?.update(:value => password)
  end


  def configuration?
    Configuration.all
  end

  def vagrant_hosts?
    Configuration.first(:config_option => 'hosts')
  end

  def vagrant_sudo?
    Configuration.first(:config_option => 'sudo')
  end

  def app_installpath?
    Configuration.first(:config_option => 'app_installpath')
  end

  def vm_installpath?
    Configuration.first(:config_option => 'vm_installpath')
  end

  def update_general_config(app_path, vm_path)
    app_installpath?.update(:value => app_path)
    vm_installpath?.update(:value => vm_path)
  end

  def update_log_config(log)
    logfile?.update(:value => log)
  end

  def logfile?
    Configuration.first(:config_option => 'logfile')
  end

  def file_path?
    path = Configuration.first(:config_option => 'file_path')
    path.value
  end

  def file_id?(file)
    file_id = File.first(:name => file)
    file_id.id
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

  def save_software_build(program, command, desc, selection, file, destination)
    Software.transaction do |t|
      begin
        Software.first_or_create(:name => program, :command => command, :description => desc)
        selection.each do |software|
          Package.first_or_create(:source_id => software_id?(program), :sub_id => software_id?(software))
        end

        Datafile.first_or_create(:name => file, :source =>file_path?,  :target => destination)
        puts software_id?(program)
          puts file_id?(file)
        #Softwarefile.first_or_create(:software_id => software_id?(program), :file_id => file_id?(file))
      rescue
        t.rollback
      end
    end
  end

end
