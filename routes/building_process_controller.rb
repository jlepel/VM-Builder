require './models/buildprocessor'

buildprocessor = Buildprocessor.new

get '/setup' do
  @bit32_machine = buildprocessor.get_standard_32bit_image
  @bit64_machine = buildprocessor.get_standard_64bit_image
  @software_selection = buildprocessor.get_softwarelist

  erb :build_setup
end

put '/save' do
  #raise params.inspect
  buildprocessor.create_machine(params['machinename'], params['ip'], params['description'], params['Bit'],'0', params['progVote'], params['files'])

  redirect '/'
end

post '/status' do

end



