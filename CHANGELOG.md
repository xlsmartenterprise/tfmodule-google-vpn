# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-15

### Added

#### Core VPN Components
- Classic VPN gateway resource creation with regional deployment
- Automatic static external IP address allocation for VPN gateway
- Support for using existing external IP addresses via `vpn_gw_ip` variable
- VPN tunnel creation with configurable count via `tunnel_count` variable

#### Forwarding Rules
- ESP protocol forwarding rule for IPsec encapsulation
- UDP port 500 forwarding rule for IKE negotiation
- UDP port 4500 forwarding rule for NAT traversal

#### Routing and Traffic Management
- Static route creation for remote subnets
- Configurable route priority with default value of 1000
- Route tagging support for selective instance application via `route_tags` variable
- Local traffic selector configuration for policy-based routing
- Remote traffic selector configuration for peer-side filtering

#### Security Features
- Random IPsec shared secret generation with configurable length
- Custom shared secret support via `shared_secret` variable
- IKE version selection (IKEv1 or IKEv2) with IKEv2 as default

#### Customization Options
- Custom tunnel naming with `tunnel_name_prefix` variable
- Default tunnel naming pattern: `{network}-{gateway_name}-tunnel-{number}`
- Flexible tunnel count configuration (1 to N tunnels per gateway)