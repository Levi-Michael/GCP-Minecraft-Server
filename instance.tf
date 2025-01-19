module "instance-group" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/compute-vm"
  project_id    = module.project.project_id
  zone          = var.zone
  name          = "${module.project.project_id}-ilb"
  instance_type = var.instance_type
  network_interfaces = [{
    network    = module.vpc.self_link
    subnetwork = module.vpc.subnets["${var.region}/minecraft-subnet"].self_link
    tags       = ["minecraft-server"]
  }]
  boot_disk = {
    initialize_params = {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
      size  = 80
      type  = "pd-ssd"
    }
  }
  # service_account = {
  #   email  = var.service_account.email
  #   scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  # }
  metadata = {
    "startup-script" = file("DATA/setup_minecraft_server.sh")
  }
  group = { named_ports = {} }

  depends_on = [module.project]
}
