# Prerequisites

This section is written for workshop instructors preparing the environment before participants start the lab.

## Access and Accounts

- Access to a RHEL 9 instance with internet egress.
- Access to Red Hat Customer Portal for AAP installer downloads.
- Access to a Dynatrace tenant with rights to deploy apps and settings.
- Access to the workshop repository.

## Host Requirements

- RHEL 9 with sudo privileges.
- Podman installed and usable by the target user.
- Python 3 and ansible-core installed.
- DNS or public hostname assigned for workshop access.

## Required Inputs You Should Prepare

- AAP public hostname.
- AAP administrator password.
- Dynatrace environment URL and required tokens.
- Workshop service account details used by Controller and EDA.

## Software and Collections

Install required packages and Ansible collections as described in the repository setup documentation.

```bash
cd ~/workshop-destination-automation/ansible
mkdir -p ~/.ansible/collections
ansible-galaxy collection install -r requirements.yml
```

## Instructor Readiness Checklist

- [ ] Verify connectivity to required registries and APIs.
- [ ] Confirm workshop host has available CPU, memory, and disk for containers.
- [ ] Validate that port access policies allow workshop traffic.
- [ ] Confirm all required secrets are available before starting provision.

Continue to [Provision](provision.md).
