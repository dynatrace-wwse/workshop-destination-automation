# Provision

Provisioning establishes your automation control plane on RHEL 9 and prepares execution images required by workshop jobs.

## Objectives

- Install Red Hat Ansible Automation Platform (containerized) on the workshop host.
- Prepare or import Execution Environment (EE) and Decision Environment (DE) images.
- Validate the platform is ready for deployment workflows.

## Step 1: Install AAP Containerized

Set your required variables and run the install playbook.

```bash
cd ~/workshop-destination-automation/ansible
export AAP_PUBLIC_HOSTNAME="<your-public-fqdn>"
export AAP_INSTALLER_LOCAL_PATH="$HOME/redhat/ansible-automation-platform-setup-bundle.tar.gz"
export AAP_ADMIN_PASSWORD="<your-strong-password>"

ansible-playbook provision/playbooks/install_aap_containerized.yml
```

## Step 2: Apply Subscription and Validate Access

- Open the AAP web console.
- Apply your subscription/license.
- Confirm Controller and Automation Hub are reachable.

## Step 3: Build or Import Workshop Images

Use one of the following patterns.

### Option A: Build locally

```bash
ansible-playbook provision/playbooks/build_custom_ee.yml
ansible-playbook provision/playbooks/build_custom_de.yml
```

### Option B: Import prebuilt images

```bash
ansible-playbook provision/playbooks/import_custom_ee.yml
ansible-playbook provision/playbooks/import_custom_de.yml
```

Default image sources are provided in the roles and can be overridden with environment variables.

## Validation

- [ ] AAP services are healthy on the host.
- [ ] Controller login is successful.
- [ ] Required EE and DE images exist in Automation Hub and can be referenced later.

Continue to [Deploy](deploy.md).
