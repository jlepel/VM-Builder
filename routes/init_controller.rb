require_relative 'administration_controller'
require_relative 'main_controller'

not_found do
  halt 404, 'page not found'
end