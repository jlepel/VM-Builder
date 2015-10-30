require './models/software_manager'
require './models/package_manager'

software_manager = SoftwareManager.new
package_manager = PackageManager.new
software_list = software_manager.get_all

get '/software/add' do
  erb :software_add
end

put '/software/add' do
  software_manager.add(params['program'], params['command'], params['description'])
  redirect '/software/edit'
end


get '/software/edit' do
  @software_selection = software_list
  erb :software_overview
end

get '/software/:id/edit' do
  @software = software_manager.get_by_id(params[:id])

  erb :software_edit
end

put '/software/:id/edit' do
  #raise params.inspect
  software_manager.update(params[:id], params['program'], params['command'], params['description'])
  redirect '/software/edit'
end

get '/software/:id/delete' do
  @software = software_manager.get_by_id(params[:id])

  erb :software_delete
end

delete '/software/:id/delete' do
  software_manager.delete(params[:id])

  redirect '/software/edit'
end



get '/package/add' do
  @software_selection = software_list

  erb :package_add
end

post '/package/add' do
  package_manager.save(params['name'], params['description'], params['selection'], params['files'])

  redirect '/package/edit'
end

get '/package/edit' do
  @software_selection = software_list
  erb :package_overview
end

get '/package/:id/edit' do
  @software_selection = software_list
  @package_content = package_manager.get_content(params[:id])
  @package_delta = package_manager.get_delta(params[:id])
  @package = package_manager.get_by_id(params[:id])


  erb :package_edit
end

put '/package/:id' do
  package_manager.update(
      params[:id], params['package_name'], params['description'],
      params['selection'], params['files'])

  redirect '/package/edit'
end

get '/package/:id/delete' do
  @package = package_manager.get_by_id(params[:id])

  erb :package_delete
end

delete '/package/:id/delete' do
  package_manager.delete(params[:id])

  redirect '/package/edit'
end













