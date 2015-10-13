require './models/buildprocessor'

buildprocessor = Buildprocessor.new

get '/setup' do
  @bit32_machine = buildprocessor.standard_32bit?
  @bit64_machine = buildprocessor.standard_64bit?
  @software_selection = buildprocessor.get_softwarelist

  erb :build_setup
end

put '/save' do
  #raise params.inspect
  machine_name = params['machinename']
  software = params['progVote']
  buildprocessor.save_build(machine_name, params['ip'], params['description'], params['Bit'],'0', software)
  buildprocessor.create_folder(machine_name)

  if software.nil?
    buildprocessor.create_vagrantfile(machine_name, false)
  else
    buildprocessor.create_ansiblefile(machine_name, software)
    buildprocessor.create_vagrantfile(machine_name, true)
  end

  buildprocessor.start_vm(machine_name)
  buildprocessor.check_build(machine_name) ? buildprocessor.set_machine_status(machine_name, 1) : buildprocessor.set_machine_status(machine_name, 0)

  redirect '/'
end

post '/status' do

end

