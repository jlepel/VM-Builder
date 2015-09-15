require './models/administration_manager'

admin_manager = Administration_Manager.new

get '/add' do

  erb :software_add
end

post '/add' do
  puts params['program']
  admin_manager.add_software(params['program'], params['command'], params['description'])
  redirect '/add'
end


get '/editor' do

end

get '/edit' do

end

get '/delete' do

end


