require './helpers/persistence_handler'
class Software_Editor

  def initialize
    @persistence_handler = PersistenceHandler.new
  end

  def get_software
    @persistence_handler.all_software?
  end

  def save_build(program, command, desc, selection, file, destination)

    if selection.nil? && ((file.nil? || file == 0))
      puts 'nur program'
      @persistence_handler.save_software(program, command, desc)
    end

    if !selection.nil? && file.nil?
      puts 'prog + selection'
      @persistence_handler.save_software_bundle(program, command, desc, selection)
    end

    if !selection.nil? && !file.nil?
      puts 'prog + selection + file'
      @persistence_handler.save_software_build(program, command, desc, selection, file, destination)
    end

    if selection.nil? && !file.nil?
      puts 'prog + file'
    end







  end

  def save_file(file)

  end



end