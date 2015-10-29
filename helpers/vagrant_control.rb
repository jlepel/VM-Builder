require './helpers/persistence_handler'

class VagrantControl

  FILENAME = 'Vagrantfile'


  def initialize()
    @persistence_handler = PersistenceHandler.new
  end

  def get_application_logpath
    @persistence_handler.get_logfile_path
  end

  def machine_logpath
    @persistence_handler.get_machine_logfile
  end

  def startup(machine_name)
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_logpath
    ('vagrant up | tee ' + get_application_logpath + ' ' + machine_log_path)
  end

  def login(machine_name)
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_logpath
    ('vagrant ssh | tee -a ' + get_application_logpath + ' ' + machine_log_path)
  end

  def destroy(machine_name)
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_logpath
    ('vagrant destroy -f | tee -a ' + get_application_logpath + ' ' + machine_log_path)
  end

  def share(machine_name)
    http = '--disable-http'
    https = '--https PORT'
    ssh = '--ssh'

    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_log_path
    ('vagrant share ' + http + ' | tee -a ' + get_application_logpath + ' ' + machine_log_path)
  end

  def halt(machine_name)
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_logpath
    ('vagrant halt | tee -a ' + get_application_logpath + ' ' + machine_log_path)
  end

  def export(machine_name)
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_logpath
    ('vagrant package --output ' + machine_name + ' | tee -a ' + get_application_logpath + ' ' + machine_log_path)
  end

  def create_vagrant_file(machine_name, switch)
    write_option = 'w'
    image = @persistence_handler.get_machine_image(machine_name)
    image_name = image.vm_name
    url = image.url
    ip = @persistence_handler.get_machine_ip(machine_name)


    path = @persistence_handler.get_vm_installpath.concat(machine_name) << '/'
    path_file = path.concat(FILENAME)

    open(path_file, write_option) { |i|
      i.write("Vagrant.configure(\"2\") do |conf|\n")
        i.write("\t" + 'conf.vm.box' +  ' = '  + "\"#{image_name}\"" + "\n")
        i.write("\t" + 'conf.vm.box_url' + ' = ' + "\"#{url}\"" + "\n")
        i.write("\t" + 'conf.vm.network :private_network, ip: ' + "\"#{ip}\"" + "\n")
        i.write("\t" + 'conf.ssh.insert_key = \'true\''  + "\n" + "\n")

        if switch
          i.write("\t" + 'conf.vm.provision "ansible" do |ansible|'+ "\n")
          i.write("\t" + 'ansible.playbook = "' + machine_name + '.yaml"'+ "\n")
          i.write("\t" + 'end' + "\n" + "\n")
        end

        i.write("\t" + 'conf.vm.provider :virtualbox do |vb|'+ "\n")
        i.write("\t" + 'vb.name = ' + "\"#{machine_name}\"" + "\n")
        i.write("\t" + 'end'+ "\n" + "\n")
      i.write('end')
    }
  end

  def build_ready?(machine_name)
    @pass = false
    machine_log_path = @persistence_handler.get_vm_installpath + machine_name + '/' + machine_logpath
    buildup = open(machine_log_path).grep(/.*(Machine booted and ready).*/)
    buildup.empty? ? @pass=false : @pass=true
    @pass
  end


  def machine_destroyed?(machine_name)

  end

end