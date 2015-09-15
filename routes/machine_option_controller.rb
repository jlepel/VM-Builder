require './models/machine_manager'

@machine_manager = MachineManager.new

get '/:id/destroy' do
  @machine = @machine_manager.machine?(params[:id])
  @title = "Confirm deletion of Machine ##{params[:id]}"
  erb :destroy
end

delete '/:id' do
  @machine_manager.delete(params[:id])
  redirect '/'
end


get '/import' do
  erb :import
end

get '/export' do
  erb :ExportView
end

get '/:id/share' do
  @share = vmbuilder.share(params[:id])
  # eigene share info seite
  erb :ShareView
end

