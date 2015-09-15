require './models/software_editor'

software_editor = Software_Editor.new


get '/software_config' do
  @software_selection = software_editor.get_software
  erb :software_config
end

post '/software_config' do
  #raise params.inspect

  software_editor.save_build(params['program'], params['command'], params['description'], params['selection'], params[:file][:filename], params['destination'])
  #puts software = params['selection']
  #puts destination = params['destination']
  #puts tempfile = params[:file][:tempfile]




end














