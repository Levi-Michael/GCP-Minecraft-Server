module "project" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/project"
  billing_account = var.billing_account
  name            = var.project_id
  prefix          = var.prefix
  services = [
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "networkmanagement.googleapis.com",
    "iap.googleapis.com"
  ]
}
