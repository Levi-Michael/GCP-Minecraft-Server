# # DDoS Protection
# resource "google_compute_security_policy" "minecraft_ddos_policy" {
#   project = module.project.project_id
#   name    = "minecraft-ddos-policy"

#   rule {
#     priority    = 2147483647
#     description = "Allow Minecraft"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["*"] # Update this with trusted IPs or reduce the range
#       }
#     }
#     action = "allow"
#   }

#   rule {
#     priority    = 2000
#     description = "Deny all other traffic"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["*"]
#       }
#     }
#     action = "deny(403)"
#   }

# }
