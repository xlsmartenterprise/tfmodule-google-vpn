output "project_id" {
  description = "The Project-ID"
  value       = google_compute_vpn_gateway.vpn_gateway.project
}

output "name" {
  description = "The name of the Gateway"
  value       = google_compute_vpn_gateway.vpn_gateway.name
}

output "gateway_self_link" {
  description = "The self-link of the Gateway"
  value       = google_compute_vpn_gateway.vpn_gateway.self_link
}

output "network" {
  description = "The name of the VPC"
  value       = google_compute_vpn_gateway.vpn_gateway.network
}

output "gateway_ip" {
  description = "The VPN Gateway Public IP"
  value       = local.vpn_gw_ip
}

output "vpn_tunnels_names" {
  description = "The VPN tunnel names"
  value       = google_compute_vpn_tunnel.tunnel[*].name
}

output "vpn_tunnels_self_link" {
  description = "The VPN tunnel self-links"
  value       = google_compute_vpn_tunnel.tunnel[*].self_link
}

output "ipsec_secret" {
  description = "The shared secret"
  value       = google_compute_vpn_tunnel.tunnel[*].shared_secret
  sensitive   = true
}
