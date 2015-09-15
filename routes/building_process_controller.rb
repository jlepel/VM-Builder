require './models/buildprocessor'

buildprocessor = Buildprocessor.new

get '/setup' do
  @bit32_machine = buildprocessor.standard_32bit?
  @bit64_machine = buildprocessor.standard_64bit?
  @software_selection = buildprocessor.get_software

  erb :build_setup
end

put '/save' do
  machine_name = params['machinename']
  software = params['progVote']
  buildprocessor.save_build(machine_name, params['ip'], params['description'], params['Bit'],'0', software)
  buildprocessor.create_folder(machine_name)
  #buildprocessor.create_vagrantfile(machine_name)
  #buildprocessor.create_ansiblefile(machine_name, software)
  #buildprocessor.start_vm(machine_name)

  redirect '/'
end

post '/status' do

end

