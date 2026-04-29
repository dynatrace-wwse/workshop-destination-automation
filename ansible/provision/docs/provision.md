# Provision Function

## Purpose

The `provision/` function prepares and bootstraps foundational platform components for the workshop, especially AAP containerized installation and custom environment images.

Execution guidance:

- These playbooks are currently plain-Ansible workflows.
- No matching AAP job templates are defined for the provision playbooks in the current controller bootstrap role.
- In practice, provision is used before the AAP workshop environment is fully configured.

## Playbooks

### `provision/playbooks/install_aap_containerized.yml`

- Purpose: perform the all-in-one AAP 2.6 containerized installation.
- Role: `aap_containerized_install`
- Execution mode: plain Ansible.

### `provision/playbooks/seed_hub_collections.yml`

- Purpose: seed bundled Automation Hub collections after AAP has already been installed.
- Role/task entry: `aap_containerized_install` with `tasks_from: seed_hub.yml`
- Execution mode: plain Ansible.
- Operational note: explicitly documented as post-install only.

### `provision/playbooks/seed_hub_collections_inner.yml`

- Purpose: internal helper playbook used by the Hub seeding workflow.
- Execution mode: internal plain-Ansible helper only.
- Operational note: not intended for direct operator use.

### `provision/playbooks/build_custom_ee.yml`

- Purpose: build and optionally push custom execution environment images for AAP.
- Role: `build_custom_ee`
- Execution mode: plain Ansible.
- Follow-up: intended to be registered later in AAP with `deploy/playbooks/configure_aap.yml` or administrative updates.

### `provision/playbooks/build_custom_de.yml`

- Purpose: build a custom decision environment image for EDA rulebook activations.
- Role: `build_custom_de`
- Execution mode: plain Ansible.
- Follow-up: intended to be registered later with `deploy/playbooks/configure_eda.yml`.

### `provision/playbooks/import_custom_de.yml`

- Purpose: import an existing decision environment image and push it to the configured Automation Hub registry without rebuilding.
- Role: `import_custom_de`
- Execution mode: plain Ansible.
- Defaults: source image defaults to `ghcr.io/dynatrace-wwse/destination-automation-dt-de:1.0`.
- Overrides: source image can be set via environment variable `DE_BASE_IMAGE` or extra var `de_base_image`.
- Follow-up: intended to be registered later with `deploy/playbooks/configure_eda.yml`.

### `provision/playbooks/import_custom_ee.yml`

- Purpose: import existing execution environment images and push them to the configured Automation Hub registry without rebuilding.
- Role: `import_custom_ee`
- Execution mode: plain Ansible.
- Defaults:
  - Podman EE source image defaults to `ghcr.io/dynatrace-wwse/destination-automation-podman-ee:1.0`.
  - OneAgent EE source image defaults to `ghcr.io/dynatrace-wwse/destination-automation-oneagent-ee:1.0`.
- Overrides:
  - Podman EE source image can be set via environment variable `EE_PODMAN_BASE_IMAGE` or extra var `ee_podman_base_image`.
  - OneAgent EE source image can be set via environment variable `EE_ONEAGENT_BASE_IMAGE` or extra var `ee_oneagent_base_image`.
- Follow-up: intended to be registered later in AAP with `deploy/playbooks/configure_aap.yml` or administrative updates.

## Roles

### `provision/roles/aap_containerized_install`

- Used by `install_aap_containerized.yml` and the Hub seeding flow.
- Major responsibilities:
  - run preflight checks
  - prepare the host OS
  - stage the installer and extracted content
  - build the installer inventory (including optional `[ansiblemcp]` group and MCP `[all:vars]` entries)
  - execute the installer (reruns reconciliation if MCP is enabled but not yet deployed)
  - validate the resulting AAP installation
  - generate an admin Personal Access Token (PAT) for MCP access and persist it to `AAP_ADMIN_TOKEN_FILE`
  - validate the MCP server container, HTTPS endpoint on port 8448, and token-authenticated toolset access
- Toggle MCP deployment with the `AAP_INSTALL_MCP_SERVER` environment variable (default: `true`).
- See [aap_containerized_quickstart.md](aap_containerized_quickstart.md) for MCP environment variables and post-install token usage.

### `provision/roles/build_custom_ee`

- Used by `build_custom_ee.yml`.
- Installs or validates `ansible-builder`, prepares Podman and registry access, builds execution-environment profiles, and summarizes/pushes results.

### `provision/roles/build_custom_de`

- Used by `build_custom_de.yml`.
- Mirrors the EE build pattern for decision environments, including builder validation, registry setup, working-directory preparation, and build profile execution.

### `provision/roles/import_custom_de`

- Used by `import_custom_de.yml`.
- Imports a prebuilt decision environment image, validates source image availability, tags it for the target registry, and pushes it to Automation Hub.
- Reuses the same registry and TLS handling pattern as the custom DE build role but skips ansible-builder and image build steps.

### `provision/roles/import_custom_ee`

- Used by `import_custom_ee.yml`.
- Imports prebuilt podman and oneagent execution environment images, validates source image availability, tags them for the target registry, and pushes them to Automation Hub.
- Reuses the same registry and TLS handling pattern as the custom EE build role but skips ansible-builder and image build steps.

## AAP vs Plain Ansible Summary

Prefer plain `ansible-playbook`:

- `install_aap_containerized.yml`
- `seed_hub_collections.yml`
- `seed_hub_collections_inner.yml`
- `build_custom_ee.yml`
- `build_custom_de.yml`
- `import_custom_de.yml`
- `import_custom_ee.yml`
