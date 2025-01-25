output "nlb-ext-ip" {
  value = module.net-lb-ext.forwarding_rule_addresses
}
