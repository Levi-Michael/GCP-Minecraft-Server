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

# # RSA key of size 4096 bits
# resource "tls_private_key" "minecraft-private_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "tls_self_signed_cert" "example" {
#   private_key_pem       = tls_private_key.minecraft-private_key.private_key_pem
#   validity_period_hours = 3600
#   early_renewal_hours   = 3

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
#   subject {
#     common_name  = "${module.project.project_id}-ssl"
#     organization = module.project.project_id
#   }
# }
