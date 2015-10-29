require './models/software_editor'

software_editor = Software_Editor.new

get '/package/add' do
  @software_selection = software_editor.get_softwarelist
  erb :package_add
end

post '/package/add' do

  #file_name = nil
  #if params[:file] && params[:file][:filename]
  #  file_name = params[:file][:filename]
  #end
  software_editor.save_build(
      params['program'], params['command'], params['description'],
      params['selection'], params['files'])

  redirect '/package/add'
end


get '/software/add' do
  erb :software_add
end

put '/software/add' do
  #raise params.inspect
  software_editor.upload(params['files'])
  software_editor.add_software_file_bundle(params['program'], params['command'], params['description'], params['files'])
  redirect '/add'
end


get '/software/edit' do
  @software_selection = software_editor.get_softwarelist
  erb :software_overview
end

get '/software/:id/edit' do
  @software = software_editor.get_software(params[:id])
  erb :software_edit
end

put '/software/:id/edit' do
  #raise params.inspect
  software_editor.update_software(params[:id], params['program'], params['command'], params['description'])
  redirect '/'
end

get '/software/:id/delete' do


end

delete '/software/:id/delete' do

end

get '/package/edit' do
  @software_selection = software_editor.get_softwarelist
  erb :package_overview
end

get '/package/:id/edit' do
  @software_selection = software_editor.get_softwarelist
  @package_content = software_editor.get_bundle_content(params[:id])
  @package_delta = software_editor.get_bundle_delta(params[:id])
  @package = software_editor.get_software(params[:id])
  erb :package_edit
end

put '/package/:id' do
  raise params.inspect
  puts params['selection']
  #software_editor.update_package(
      #params[:id], params['package_name'], params['description'],
      #params['selection'], params['files'])
  #redirect '/package/edit'
end
















