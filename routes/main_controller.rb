require './models/vm_builder'
require_relative 'machine_option_controller'
require_relative 'Building_Process_Controller'


vmbuilder = VMBuilder.new


get '/' do
  @show_machines = vmbuilder.machines?

  erb :init
end




