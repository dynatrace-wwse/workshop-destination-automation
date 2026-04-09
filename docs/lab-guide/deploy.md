# Deploy

Deployment uses Red Hat AAP to configure platform objects and deliver both observability components and the AI application stack.

## Objectives

- Configure AAP Controller and EDA objects for the workshop.
- Deploy Dynatrace apps and API settings.
- Deploy EdgeConnect and OneAgent.
- Build and deploy the easyTravel AI Travel Advisor stack using Podman workflows.

## Step 1: Configure AAP and EDA

Run the bootstrap playbooks from the ansible directory.

```bash
cd ~/workshop-destination-automation/ansible
ansible-playbook deploy/playbooks/configure_aap.yml
ansible-playbook deploy/playbooks/configure_eda.yml
```

After playbook completion, review credentials and inventory objects in the AAP UI.

## Step 2: Deploy Dynatrace Components

Launch the relevant AAP job templates for:

- Dynatrace AppEngine apps
- Dynatrace API configuration
- Dynatrace EdgeConnect (when private network connectivity requires it)
- Dynatrace OneAgent on target hosts

## Step 3: Deploy the AI Travel Advisor Application

Run the workshop app deployment workflow from AAP:

- Build images
- Deploy Podman services
- Verify health endpoints and public access

## Validation

- [ ] Dynatrace components are installed and authenticated.
- [ ] OneAgent reports data from the workshop host.
- [ ] App stack is reachable and healthy.
- [ ] AAP workflows complete without failed tasks.

Continue to [Observe and Automate](observe-and-automate.md).
