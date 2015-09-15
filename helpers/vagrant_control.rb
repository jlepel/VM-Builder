require './helpers/persistence_handler'

class VagrantControl

  FILENAME = 'Vagrantfile'

  def initialize
    @persistence_handler = PersistenceHandler.new
  end

  def log_path?
    @persistence_handler.logfile?.value
  end

  def startup_command?
    ('vagrant up >> ' + log_path?)
  end

  def login_command?
    ('vagrant ssh >> ' + log_path?)
  end

  def destroy_command?
    ('vagrant destroy -f >> ' + log_path?)
  end

  def share_command?
    ('vagrant share --ssh>> ' + log_path?)
  end

  def create_file(machine_name)
    write_option = 'w'
    image = @persistence_handler.machine_image?(machine_name)
    url = image.url
    ip = @persistence_handler.machine_ip?(machine_name)


    path = @persistence_handler.vm_installpath?.value.concat(machine_name) << '/'
    path_file = path.concat(FILENAME)

    open(path_file, write_option) { |i|
      i.write("Vagrant.configure(\"2\") do |conf|\n")
        i.write("\t" + 'conf.vm.box' +  ' = '  + "\"#{image.vm_name}\"" + "\n")
        i.write("\t" + 'conf.vm.box_url' + ' = ' + "\"#{url}\"" + "\n")
        i.write("\t" + 'conf.vm.network :private_network, ip: ' + "\"#{ip}\"" + "\n" + "\n")

        i.write("\t" + 'conf.vm.provision "ansible" do |ansible|'+ "\n")
        i.write("\t" + 'ansible.playbook = "' + machine_name + '.yaml"'+ "\n")
        i.write("\t" + 'end' + "\n" + "\n")

        i.write("\t" + 'conf.vm.provider :virtualbox do |vb|'+ "\n")
        i.write("\t" + 'vb.name = ' + "\"#{machine_name}\"" + "\n")
        i.write("\t" + 'end'+ "\n" + "\n")
      i.write('end')
    }
  end
end