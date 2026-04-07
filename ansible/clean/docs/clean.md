# Clean Function

## Purpose

The `clean/` function removes deployed workshop resources. It is the teardown counterpart to the deploy function and is intended for predictable cleanup of:

- Podman application resources (containers, network, optional volumes, image)
- Dynatrace workshop configuration (Monaco objects, API settings, EdgeConnect, OneAgent)

Execution guidance:

- Individual cleanup playbooks have matching AAP job templates and should be preferred for workshop runs.
- The wrapper `site.yml` is a plain-Ansible orchestrator and does not have a dedicated AAP job template.

## Playbooks

### `clean/playbooks/remove_app.yml`

Purpose:

- Stops and removes the deployed application containers and network.
- Optionally removes workshop volumes (`podman_clean_remove_volumes`, default `true`).

Execution mode:

- Intended for AAP.
- Evidence: matching AAP job template exists in `deploy/roles/aap_config/defaults/main.yml`.

Role used:

- `podman_clean` with `podman_clean_action=remove_app`

### `clean/playbooks/remove_image.yml`

Purpose:

- Removes the locally built container image from Podman storage.

Execution mode:

- Intended for AAP.
- Evidence: matching AAP job template exists in `deploy/roles/aap_config/defaults/main.yml`.

Role used:

- `podman_clean` with `podman_clean_action=remove_image`

### `clean/playbooks/remove_dynatrace_edgeconnect.yml`

Purpose:

- Removes Dynatrace EdgeConnect registration(s) and local runtime artifacts.

Execution mode:

- Intended for AAP.
- Evidence: matching AAP job template exists in `deploy/roles/aap_config/defaults/main.yml` (`aap_clean_dynatrace_edgeconnect_job_template_playbook`).

Role used:

- `dynatrace_edgeconnect_clean`

### `clean/playbooks/remove_dynatrace_monaco.yml`

Purpose:

- Removes Monaco-managed Dynatrace configuration objects.

Execution mode:

- Intended for AAP.
- Evidence: matching AAP job template exists in `deploy/roles/aap_config/defaults/main.yml` (`aap_clean_dynatrace_monaco_job_template_playbook`).

Role used:

- `dynatrace_monaco_clean`

### `clean/playbooks/remove_dynatrace_api_config.yml`

Purpose:

- Removes Dynatrace Settings API objects created by workshop API configuration deployment.

Execution mode:

- Intended for AAP.
- Evidence: matching AAP job template exists in `deploy/roles/aap_config/defaults/main.yml` (`aap_clean_dynatrace_api_config_job_template_playbook`).

Role used:

- `dynatrace_api_config_clean`

### `clean/playbooks/remove_dynatrace_oneagent.yml`

Purpose:

- Uninstalls Dynatrace OneAgent from target hosts.

Execution mode:

- Intended for AAP.
- Evidence: matching AAP job template exists in `deploy/roles/aap_config/defaults/main.yml` (`aap_clean_dynatrace_oneagent_job_template_playbook`).

Role used:

- `dynatrace_oneagent_clean`

### `clean/playbooks/site.yml`

Purpose:

- Sequential wrapper that imports all cleanup playbooks in this order:
	- `remove_app.yml`
	- `remove_image.yml`
	- `remove_dynatrace_edgeconnect.yml`
	- `remove_dynatrace_monaco.yml`
	- `remove_dynatrace_api_config.yml`
	- `remove_dynatrace_oneagent.yml`

Execution mode:

- Plain Ansible.
- No matching AAP job template is defined for the wrapper playbook itself.

## Roles

### `clean/roles/podman_clean`

Purpose:

- Dispatch role for workshop cleanup operations.

What it does:

- Validates the requested clean action.
- Verifies Podman availability.
- Routes to app-resource cleanup (`remove_app`) or image cleanup (`remove_image`).
- For app cleanup, removes containers and network, and optionally removes named volumes.

Execution note:

- Used by `remove_app.yml` and `remove_image.yml`.

### `clean/roles/dynatrace_edgeconnect_clean`

Purpose:

- Removes Dynatrace EdgeConnect registration and local runtime artifacts.

What it does:

- Validates required OAuth credentials.
- Acquires OAuth token and deletes matching EdgeConnect registrations via Dynatrace API.
- Removes local Podman EdgeConnect container and optional config directory.

### `clean/roles/dynatrace_monaco_clean`

Purpose:

- Removes Monaco-managed Dynatrace configuration.

What it does:

- Validates required platform credentials and manifest presence.
- Ensures pinned Monaco binary is available.
- Generates Monaco delete file and runs Monaco delete.
- Tolerates known OpenPipeline dependency constraint errors as non-fatal.

### `clean/roles/dynatrace_api_config_clean`

Purpose:

- Removes Dynatrace Settings API objects created by workshop API configuration.

What it does:

- Validates platform credentials.
- Resolves preferred/fallback Settings API base endpoint.
- Removes workshop-specific JS runtime outbound hosts, EDA webhook connection settings, and service-detection settings objects.

### `clean/roles/dynatrace_oneagent_clean`

Purpose:

- Uninstalls Dynatrace OneAgent.

What it does:

- Validates environment URL and PaaS token.
- Delegates uninstall to `dynatrace.oneagent.oneagent` role with uninstall state.

## AAP vs Plain Ansible Summary

Prefer AAP:

- `remove_app.yml`
- `remove_image.yml`
- `remove_dynatrace_edgeconnect.yml`
- `remove_dynatrace_monaco.yml`
- `remove_dynatrace_api_config.yml`
- `remove_dynatrace_oneagent.yml`

Prefer plain `ansible-playbook`:

- `site.yml`
