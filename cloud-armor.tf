# DDoS Protection
resource "google_compute_security_policy" "minecraft_ddos_policy" {
  project = module.project.project_id
  name    = "minecraft-ddos-policy"

  # Rule 1: Allow traffic from trusted IPs
  rule {
    priority    = 1000
    description = "Allow Minecraft"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.allowed_range # Update this with trusted IPs or reduce the range
      }
    }
    action = "allow"
  }

  # Default rule: Deny all other traffic
  rule {
    priority    = 2147483647
    description = "Deny all other traffic"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    action = "deny(403)"
  }

  advanced_options_config {
    log_level = "NORMAL"
  }

  depends_on = [module.project]
}
