# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"


resource "vsphere_virtual_machine" "clone" {
  count            = length(var.vm_data)
  name             = var.machine_config.hostname[count.index]
  folder           = var.folder
  resource_pool_id = var.resource_pool_id
  host_system_id   = var.host_system_id
  datastore_id     = var.datastore_id
  enable_disk_uuid = true
  wait_for_guest_net_timeout = -1
  wait_for_guest_net_routable = false

  num_cpus = var.machine_config.cpu
  memory   = var.machine_config.memory
  guest_id = var.guest_id

  network_interface {
    network_id   = var.network_id
    adapter_type = var.adapter_type
  }

  disk {
    # eagerly_scrub    = false
    thin_provisioned = true
    label            = "disk0"
    size             = var.machine_config.disk
  }

  clone {
    template_uuid = var.template_uuid
    linked_clone  = false
  }

  vapp {
    properties = {
      "guestinfo.ignition.config.data"          = base64encode(var.vm_data[count.index])
      "guestinfo.ignition.config.data.encoding" = "base64"
    }
  }
}
