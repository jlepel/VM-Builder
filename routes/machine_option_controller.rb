require './models/machine_manager'

machine_manager = MachineManager.new

get '/:id/destroy' do
  @machine = machine_manager.get_machine(params[:id])
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
  machine_manager.import(params['machine_name'], params['configs'], params['files'])
  redirect '/'
end

get '/:id/download' do

  machine_manager.export(params[:id])
  send_file "/home/greg/machines/jan/jan.tar.gz", :filename => 'jan.tar.gz', :type => 'Application/octet-stream'
  redirect '/'
end

get '/:id/export' do
  @machine = machine_manager.get_machine(params[:id])

  erb :export_machine
end



get '/:id/share' do

  @machine_name = machine_manager.get_machine(params[:id]).name
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
  @machine = machine_manager.get_machine(params[:id])
  erb :halt
end

post '/:id/halt' do
  machine_manager.halt_machine(params[:id])
  redirect '/'
end
