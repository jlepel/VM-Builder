require './helpers/vagrant_control'
require './helpers/persistence_handler'
require './helpers/file_system_manager'
class Machine_Sharing

  def initialize
    @vagrant = VagrantControl.new
    @persistence_handler = PersistenceHandler.new
    @file_system_manager = FileSystemManager.new
  end

  def share(machine_id)
    @share_name = ''
    puts machine_name = @persistence_handler.get_machine(machine_id).name
    @file_system_manager.exec(@persistence_handler.get_vm_installpath + machine_name, @vagrant.share(machine_name))
    File.open(machine_folder + @persistence_handler.get_machine_logfile) { |line|
      line.each_line do |l|
        a = l.match(/(.*)(http:.*)/)
        unless a.nil?
          @share_name = a.captures[1]
        end
      end
    }
  @share_name
  end



end