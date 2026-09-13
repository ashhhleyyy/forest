# forest

personal nixos configurations for ash.

> get it? because like ash is a type of tree and so my collection of computers is called forest

## structure

per-host configuration files are in `hosts/<hostname>/configuration.nix`. these mostly enable modules from `modules/`.

secrets are managed using agenix, and are kept in `secrets/` (for now)

`modules/` contains groups for different things:

- `modules/boot/`: configuration for different bootloaders
- `modules/common/`: configuration that is applied automatically to every host (e.g. basic user profiles, locales, etc.)
- `modules/profiles/`: generic high-level profiles for different purposes (e.g. desktop machines, or servers)
- `modules/programs/`: modules to enable different applications (mostly used on desktop machines)
- `modules/services/desktop/`: configuration for different desktop-related services
- `modules/services/infra/`: infrastructure services (e.g. backups and monitoring)
- `modules/services/servers/`: any services that run some sort of server
- `modules/services/servers/web/`: web services
- `modules/tools/`: configuration for system-level tools (e.g. podman)
- `modules/util/`: other utility modules that didn't fit elsewhere
