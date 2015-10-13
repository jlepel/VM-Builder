require './models/software_editor'

software_editor = Software_Editor.new




get '/package' do
  @software_selection = software_editor.get_softwarelist
  erb :software_package
end

post '/package' do
  #raise params.inspect
  file_name = nil
  selection = params['selection']
  destination = params['destination']


  if params[:file] && params[:file][:filename]
    file_name = params[:file][:filename]
  end

  software_editor.save_build(
      params['program'], params['command'], params['description'],
      selection, file_name, destination)

  redirect '/package'
end


get '/add' do
  erb :software_add
end

put '/add' do
  #raise params.inspect
  software_editor.upload(params['files'])
  software_editor.add_software_file_bundle(params['program'], params['command'], params['description'], params['files'])


  redirect '/add'
end


get '/:id/edit' do
  @software = software_editor.get_software(params[:id])
  erb :software_edit
end

put '/:id/edit' do
  #raise params.inspect
  software_editor.update_software(params[:id], params['program'], params['command'], params['description'])
  redirect '/'
end

















