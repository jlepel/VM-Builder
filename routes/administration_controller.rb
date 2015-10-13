require './models/administration_manager'
require_relative 'softwareadmin_controller'


admin_mgr = Administration_Manager.new
get '/admin' do
  @hosts = admin_mgr.get_hosts
  @sudo = admin_mgr.sudo?
  @app_installpath = admin_mgr.get_app_installpath
  @vm_installpath = admin_mgr.get_vm_installpath
  @user = admin_mgr.user?
  @password = admin_mgr.password?
  @path = admin_mgr.get_logfile_path
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
  @content = admin_mgr.get_applicationlog_content
  erb :logfile_application
end


delete '/log' do
  admin_mgr.delete_log()
  redirect '/log'
end

