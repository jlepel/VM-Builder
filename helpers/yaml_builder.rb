require 'yaml'
require './helpers/persistence_handler'
class Yaml_Builder


    def initialize
      @persistence_handler = PersistenceHandler.new
    end

    def create(machine_name, software)
      path = @persistence_handler.get_vm_installpath.concat(machine_name) << '/'
      path_file = path.concat("#{machine_name}") << '.yaml'
      File.open(path_file , 'w') {|f| f.write(yaml_body(software).to_yaml) }
    end

    private

    def yaml_body(software)
      [{'hosts' => @persistence_handler.get_vagrant_hosts, 'sudo' => @persistence_handler.vagrant_sudo?, 'tasks' =>
                                                  [{
                                                       'name' => 'General | Install required packages.',
                                                       'action' => 'apt pkg={{ item }} state=installed',
                                                       'tags' => 'common',
                                                       'with_items' => software
                                                   }]}

      ]
    end

# WENN DATEIEN VORHANDEN...DANN EINFACH AN YAML DRAN HÄNGEN?!
end