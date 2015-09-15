require './helpers/vagrant_control'
require './models/buildprocessor'

class Machine_Importer

  def initialize
    @vagrant = VagrantControl.new
    @buildprocessor = Buildprocessor.new
  end

  def import(filename)

  end

  def build_up()

  end

end