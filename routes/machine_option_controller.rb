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


get '/:id/import' do
  erb :import
end

get '/:id/export' do
  erb :export
end

get '/:id/share' do
  @test = false
  @bla = open('/home/greg/machines/dasdas/status.log').grep(/.*(Machine booted and ready).*/)



  #@share = vmbuilder.share(params[:id])
  # eigene share info seite
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