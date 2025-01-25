module "vpc" {
  source                  = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/net-vpc"
  project_id              = module.project.project_id
  name                    = "${module.project.project_id}-vpc"
  auto_create_subnetworks = false
  subnets = [
    {
      name          = "minecraft-subnet"
      ip_cidr_range = var.subnet_cidr
      region        = var.region
    }
  ]
  depends_on = [module.project]
}

module "nat" {
  source         = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/net-cloudnat"
  project_id     = module.project.project_id
  region         = var.region
  name           = "${module.project.project_id}-nat"
  router_network = module.vpc.self_link
  depends_on     = [module.vpc]
}

module "firewall" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/net-vpc-firewall"
  project_id = module.project.project_id
  network    = module.vpc.name
  default_rules_config = {
    # admin_ranges = ["10.0.0.0/8"]
    disabled = true
  }
  egress_rules = {
    allow-egress-internet = {
      description   = "Allow all egress traffic to the internet"
      deny          = false
      direction     = "EGRESS"
      priority      = 1001
      source_ranges = ["0.0.0.0/0"]
      rules = [
        {
          protocol = "all"
        }
      ]
      target_tags = ["minecraft-server"]
    }
  }
  ingress_rules = {
    allow-ssh = {
      description   = "Allow Minecraft ssh traffic from google"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["35.235.240.0/20"]
      rules = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      enable_logging = {
        include_metadata = true
      }
      target_tags = ["minecraft-server"]
    }
    allow-minecraft = {
      description   = "Allow Minecraft traffic"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = var.allowed_range # Update this with trusted IPs or reduce the range
      rules = [
        {
          protocol = "tcp"
          ports    = ["25565"]
        }
      ]
      enable_logging = {
        include_metadata = true
      }
      target_tags = ["minecraft-server"]
    }
  }

  depends_on = [module.vpc]
}

module "net-lb-ext" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/net-lb-ext"
  project_id = module.project.project_id
  region     = var.region
  name       = "${module.project.project_id}-nlb"
  backends = [{
    group = module.instance-group.group.id
  }]
  health_check_config = {
    tcp = {
      port = 25565
    }
  }
  depends_on = [module.project, module.instance-group]
}
