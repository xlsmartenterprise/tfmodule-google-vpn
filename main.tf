locals {
  tunnel_name_prefix    = var.tunnel_name_prefix != "" ? var.tunnel_name_prefix : "${var.network}-${var.gateway_name}-tunnel"
  default_shared_secret = var.shared_secret != "" ? var.shared_secret : random_id.ipsec_secret.b64_url
  vpn_gw_ip             = var.vpn_gw_ip == "" ? google_compute_address.vpn_gw_ip[0].address : var.vpn_gw_ip
}

# Generate random IPsec secret
resource "random_id" "ipsec_secret" {
  byte_length = var.ipsec_secret_length
}

# Static External IP for the VPN Gateway
resource "google_compute_address" "vpn_gw_ip" {
  count   = var.vpn_gw_ip == "" ? 1 : 0
  name    = "ip-${var.gateway_name}"
  region  = var.region
  project = var.project_id
}

# VPN Gateways
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = var.gateway_name
  network = var.network
  region  = var.region
  project = var.project_id
}

# Associate external IP/Port-range to VPN-GW by using Forwarding rules
resource "google_compute_forwarding_rule" "vpn_esp" {
  name        = "${google_compute_vpn_gateway.vpn_gateway.name}-esp"
  ip_protocol = "ESP"
  ip_address  = local.vpn_gw_ip
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
  project     = var.project_id
  region      = var.region
}

resource "google_compute_forwarding_rule" "vpn_udp500" {
  name        = "${google_compute_vpn_gateway.vpn_gateway.name}-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = local.vpn_gw_ip
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
  project     = var.project_id
  region      = var.region
}

resource "google_compute_forwarding_rule" "vpn_udp4500" {
  name        = "${google_compute_vpn_gateway.vpn_gateway.name}-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = local.vpn_gw_ip
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
  project     = var.project_id
  region      = var.region
}

# Creating the VPN tunnels - Static routing only
resource "google_compute_vpn_tunnel" "tunnel" {
  count         = var.tunnel_count
  name          = var.tunnel_count == 1 ? format("%s-%s", local.tunnel_name_prefix, "1") : format("%s-%d", local.tunnel_name_prefix, count.index + 1)
  region        = var.region
  project       = var.project_id
  peer_ip       = var.peer_ips[count.index]
  shared_secret = local.default_shared_secret

  target_vpn_gateway      = google_compute_vpn_gateway.vpn_gateway.self_link
  local_traffic_selector  = var.local_traffic_selector
  remote_traffic_selector = var.remote_traffic_selector

  ike_version = var.ike_version

  depends_on = [
    google_compute_forwarding_rule.vpn_esp,
    google_compute_forwarding_rule.vpn_udp500,
    google_compute_forwarding_rule.vpn_udp4500,
  ]
}

# Create Routes for static routing
resource "google_compute_route" "route" {
  count      = var.tunnel_count * length(var.remote_subnet)
  name       = "${google_compute_vpn_gateway.vpn_gateway.name}-tunnel${floor(count.index / length(var.remote_subnet)) + 1}-route${count.index % length(var.remote_subnet) + 1}"
  network    = var.network
  project    = var.project_id
  dest_range = var.remote_subnet[count.index % length(var.remote_subnet)]
  priority   = var.route_priority
  tags       = var.route_tags

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel[floor(count.index / length(var.remote_subnet))].self_link

  depends_on = [google_compute_vpn_tunnel.tunnel]
}
