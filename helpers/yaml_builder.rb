require 'yaml'
require './helpers/persistence_handler'
class Yaml_Builder


    def initialize()
      @persistence_handler = PersistenceHandler.new
    end

    def create(machine_name, software)
      path = @persistence_handler.vm_installpath?.value.concat(machine_name) << '/'
      path_file = path.concat("#{machine_name}") << '.yaml'
      File.open(path_file , "w") {|f| f.write(yaml_body(software).to_yaml) }
    end

    private
    # @param [Array] items_to_install; an arraylist with all program items
    def yaml_body(software)
      [{'hosts' => @persistence_handler.vagrant_hosts?.value, 'sudo' => @persistence_handler.vagrant_sudo?.value, 'tasks' =>
                                                  [{
                                                       'name' => 'General | Install required packages.',
                                                       'action' => 'apt pkg={{ item }} state=installed',
                                                       'tags' => 'common',
                                                       'with_items' => software
                                                   }]}

      ]
    end


end