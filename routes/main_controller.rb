require './models/vm_builder'
require_relative 'machine_option_controller'
require_relative 'building_process_controller'


vmbuilder = VMBuilder.new


get '/' do
  @show_machines = vmbuilder.get_all_machines

  erb :init
end





