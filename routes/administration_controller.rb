require './models/administration_manager'
require_relative 'softwareadmin_controller'


admin_mgr = Administration_Manager.new
get '/admin' do
  @hosts = admin_mgr.hosts?
  @sudo = admin_mgr.sudo?
  @app_installpath = admin_mgr.app_installpath?
  @vm_installpath = admin_mgr.vm_installpath?
  @user = admin_mgr.user?
  @password = admin_mgr.password?
  @path = admin_mgr.logfile_path?
  @ubuntu32 = admin_mgr.ubuntu32?
  @ubuntu64 = admin_mgr.ubuntu64?

  erb :administration
end

put '/ansible' do
  admin_mgr.update_ansible_config(params['hosts'], params['sudo'] )
  redirect '/admin'
end


put '/vagrant' do
  admin_mgr.update_vagrant_config(params['user'], params['password'] )
  redirect '/admin'
end

put '/configuration' do
  admin_mgr.update_general_config(params['app_installpath'], params['vm_installpath'] )
  redirect '/admin'
end

put '/log' do
  admin_mgr.update_log_config(params['logpath'])
  #muss getestet werden!
  admin_mgr.create_logfile(params['logpath'])
  redirect '/admin'
end

put '/machines' do
  admin_mgr.update_standardmachines(params['ubuntu32'], params['ubuntu64'])
  redirect '/admin'
end

get '/log' do
  @content = admin_mgr.log_content?
  erb :logfile
end


delete '/log' do
  admin_mgr.delete_log()
  redirect '/log'
end


get '/add' do

  erb :software_add
end

post '/add' do
  puts params['program']
  admin_mgr.add_software(params['program'], params['command'], params['description'])
  redirect '/add'
end