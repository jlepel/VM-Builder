require './models/machine_exporter'
require './models/machine_importer'
require './models/machine_sharing'
require './models/machine_delete'
require './helpers/persistence_handler'


class MachineManager

  def initialize
    @import = Machine_Importer.new
    @export = Machine_Exporter.new
    @share = Machine_Sharing.new
    @delete = Machine_Delete.new
    @persistence_handler = PersistenceHandler.new
  end


  def delete(machine_id)
    @delete.destroy_vm(machine_id)
    @delete.delete_folder(machine_id)
    @delete.delete_machine(machine_id)
  end

  def share(machine_id)

  end

  def import

  end

  def export

  end

  def machine?(id)
    @persistence_handler.machine?(id)
  end



end