variable "project_id" {
  type        = string
  description = "The ID of the project where this VPC will be created"
}

variable "network" {
  type        = string
  description = "The name of VPC being created"
}

variable "region" {
  type        = string
  description = "The region in which you want to create the VPN gateway"
}

variable "gateway_name" {
  type        = string
  description = "The name of VPN gateway"
  default     = "test-vpn"
}

variable "tunnel_count" {
  type        = number
  description = "The number of tunnels from each VPN gw (default is 1)"
  default     = 1
}

variable "tunnel_name_prefix" {
  type        = string
  description = "The optional custom name of VPN tunnel being created"
  default     = ""
}

variable "local_traffic_selector" {
  description = <<EOD
Local traffic selector to use when establishing the VPN tunnel with peer VPN gateway.
Value should be list of CIDR formatted strings and ranges should be disjoint.
EOD

  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "remote_traffic_selector" {
  description = <<EOD
Remote traffic selector to use when establishing the VPN tunnel with peer VPN gateway.
Value should be list of CIDR formatted strings and ranges should be disjoint.
EOD

  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "peer_ips" {
  type        = list(string)
  description = "IP address of remote-peer/gateway"
}

variable "remote_subnet" {
  description = "remote subnet ip range in CIDR format - x.x.x.x/x"
  type        = list(string)
}

variable "shared_secret" {
  type        = string
  description = "Please enter the shared secret/pre-shared key"
  default     = ""
}

variable "route_priority" {
  description = "Priority for static route being created"
  type        = number
  default     = 1000
}

variable "ike_version" {
  type        = number
  description = "Please enter the IKE version used by this tunnel (default is IKEv2)"
  default     = 2
}

variable "vpn_gw_ip" {
  type        = string
  description = "Please enter the public IP address of the VPN Gateway, if you have already one. Do not set this variable to autocreate one"
  default     = ""
}

variable "route_tags" {
  type        = list(string)
  description = "A list of instance tags to which this route applies."
  default     = []
}

variable "ipsec_secret_length" {
  type        = number
  description = "The length of shared secret for VPN tunnels"
  default     = 8
}
