require './models/software_editor'

software_editor = Software_Editor.new


get '/software_config' do
  @software_selection = software_editor.get_software
  erb :software_config
end

post '/software_config' do
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





end














