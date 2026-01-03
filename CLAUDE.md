# Infinity Lab - NixOS Configuration

This is a NixOS flake-based configuration repository managing multiple hosts.

## Hosts

- `atlas` - Desktop workstation
- `orion` - Laptop
- `serveros` - Server

## Structure

- `nixos/hosts/` - Host-specific configurations
- `nixos/components/` - Reusable service modules (docker, gaming, ssh, etc.)
- `nixos/programs/` - Program configurations (zsh, nvim, firefox, etc.)
- `nixos/desktop-environments/` - DE configurations (hyprland, sway, kde, cosmic, i3)
- `nixos/home/` - Home Manager configurations per host
- `nixos/hw/` - Hardware-specific configurations
- `nixos/secrets/` - Agenix secrets
- `pkgs/` - Custom packages

## MCP: nixos

This project has the `mcp-nixos` MCP server configured for NixOS assistance.

### When to Use

Use the nixos MCP tools when:

- Looking up NixOS module options (e.g., `services.nginx`, `programs.zsh`)
- Searching for available NixOS packages
- Checking Home Manager options for program configuration
- Verifying correct option syntax, types, or default values
- Exploring what options a service or program exposes

### Available Tools

- `nixos_search` - Search for NixOS packages by name
- `nixos_options` - Look up NixOS configuration options
- `nixos_options_search` - Search for NixOS options by keyword
- `home_manager_options` - Look up Home Manager options
- `home_manager_options_search` - Search Home Manager options by keyword

### Examples

- Before adding a new service, search its options: `nixos_options_search("nginx")`
- Check package availability: `nixos_search("neovim")`
- Verify Home Manager option syntax: `home_manager_options("programs.zsh.enable")`
