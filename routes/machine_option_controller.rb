require './models/machine_manager'

machine_manager = MachineManager.new

get '/:id/destroy' do
  @machine = machine_manager.get_machines(params[:id])
  @title = "Confirm deletion of Machine ##{params[:id]}"
  erb :destroy
end



delete '/:id/destroy' do
  machine_manager.delete(params[:id])
  redirect '/'
end


get '/import' do
  erb :import
end

post '/import' do
  machine_manager.import(params['machine_name'], params['configs'])
  redirect '/'
end

get '/:id/export' do
  @machine_name = machine_manager.get_machines(params[:id]).name
  erb :export_machine
end

get '/download/*/*' do |id ,filename|
  puts [id,filename]
  #machine_manager.export(params[:id])
  #send_file "/home/greg/machines/testmachine6/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

get '/:id/share' do

  @machine_name = machine_manager.get_machines(params[:id]).name
  #@share_name = machine_manager.share(params[:id])
  @share_name = 'superb-vicuna-4426.vagrantshare.com'

  #@share_name
  #@share_name = open('/home/greg/machines/' + @machine_name + '/status.log').grep(/(.*)(http:.*)/)
  #@share_name = machine_manager.find_in_file(@machine_name, '.*(http:.*)')[0]

  erb :share
end

get '/:id/log' do
  @content = machine_manager.get_machine_logfile(params[:id])
  erb :logfile_machine
end

get '/:id/halt' do
  @machine = machine_manager.get_machines(params[:id])
  erb :halt
end

post '/:id/halt' do
  machine_manager.halt_machine(params[:id])
  redirect '/'
end

get '/:id/start' do

end