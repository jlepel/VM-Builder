require 'yaml'
require './helpers/persistence_handler'
class Yaml_Builder


    def initialize
      @persistence_handler = PersistenceHandler.new
    end

    def create(machine_name, software, files)
      @components = Array.new
      @package_files = Array.new

      software.each { |app|
        software_part = @persistence_handler.get_software_by_name(app)

        if software_part.package == 1
          @persistence_handler.get_all_packages_by_id(software_part.id).each do |bundle_part|
            @components << @persistence_handler.get_software_by_id(bundle_part.sub_id).name
          end

          bla = Softwarefile.all(:software_id => software_part.id) # alle verknüpfungen zwischen file und pack
          bla.each do |elem|
            file = @persistence_handler.get_file_by_id(elem.datafile_id)
            @package_files << file_option_submission(file.name, file.source + file.name, file.target + file.name)
          end
        else
          @components << app
        end
      }
      path = @persistence_handler.get_vm_installpath.concat(machine_name) + '/'
      path_file = path.concat("#{machine_name}") + '.yaml'
      #puts yaml_body(@components, files, @package_files, machine_name).to_yaml
      File.open(path_file , 'w') {|f| f.write(yaml_body(@components, files, @package_files, machine_name).to_yaml) }
    end

    private

    def yaml_body(software, files, package_files ,machine_name)
      yaml_body = Array.new
      @software_bool = false
      @task_array = Array.new
      general_modul = {'hosts' => 'all', 'sudo' => 'true'}
      yaml_body << general_modul

      if !software.nil?
        @task_array << software_to_yaml(software)
      end

      if !files.nil?
        file_to_yaml(files, machine_name).each do |file|
            @task_array << file
        end
      end

      if !package_files.nil?
        @package_files.each do |file|
          @task_array << file
        end
      end

      yaml_body[0]['tasks'] = @task_array
      yaml_body
    end

    def software_to_yaml(software)
      software_option_submission(software)
    end


    def software_option_submission(software)
      {
          'name' => 'General | Install required packages.',
          'action' => 'apt pkg={{ item }} state=installed',
          'tags' => 'common',
          'with_items' => software}
    end

    def file_to_yaml(files, machine_name)
      file_array = Array.new
      files.each do |file_data|
        file_name = file_data[:file][:filename]
        source = @persistence_handler.get_vm_installpath + machine_name + '/' + file_name
        destination = file_data[:path] + file_name
        file_array << file_option_submission(file_name, source, destination)
      end

      file_array
    end



    def file_option_submission(file_name, source, destination)
      {
          'name' => 'Copy ' + file_name + ' to: ' + destination,
          'action' => 'copy src='+ source + ' dest=' + destination
      }
    end


end

#[{'tasks' => [{}, {}] }]
#    [{'hosts' => @persistence_handler.get_vagrant_hosts, 'sudo' => @persistence_handler.vagrant_sudo?, 'tasks' =>
#                                            [{
#                                                 'name' => 'General | Install required packages.',
#                                                 'action' => 'apt pkg={{ item }} state=installed',
#                                                 'tags' => 'common',
#                                                 'with_items' => software
#                                             },
#                                              {
#                                                   'name' => 'Copy selected file',
#                                                   'action' => 'copy src=httpd.conf dest=/etc/httpd/httpd.conf',
#                                                   'notify' => 'Restart Apache'
#                                               }]
#}]