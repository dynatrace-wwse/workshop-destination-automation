# Overview

This lab demonstrates how Dynatrace and Red Hat Ansible Automation Platform work together to deploy, observe, automate, and remediate a containerized AI application.

!!! warning "Not yet migrated to the Dynatrace Enablement App"
    This training has not been migrated to a fully immersive, interactive and self-service training.
    Questions or feedback? Reach out to the Center of Excellence Enablement Team via
    [GitHub Issues](https://github.com/dynatrace-wwse/codespaces-framework/issues)
    or the [feedback form](https://forms.office.com/r/QaCx6VAJe8).

## What You Will Build

- A containerized easyTravel AI Travel Advisor stack on Podman.
- Automated deployment and configuration workflows with Ansible Controller and Event-Driven Ansible (EDA).
- Dynatrace AI observability and automation integrations for runtime analysis and operational response.

## Workshop Architecture

```text
Instructor / Operator
        |
        v
Ansible Controller + EDA  ----->  Dynatrace Tenant (Apps, Settings, OneAgent, EdgeConnect)
        |
        v
RHEL 9 host with Podman  ----->  easyTravel AI Travel Advisor + supporting services
```

## Core Capabilities Covered

- Infrastructure and platform provisioning with repeatable Ansible playbooks.
- Deployment of Dynatrace apps, APIs, OneAgent, and EdgeConnect.
- Deployment of a multi-service AI workload with Ansible-controlled Podman workflows.
- Closed-loop remediation where Dynatrace events trigger EDA automation.

## AI Observability and Automation Use Cases

- Observe prompt-to-response behavior in AI workloads.
- Track model-related behavior changes and drift signals.
- Trigger automated corrections when platform health degrades.
- Compare behavior before and after model, prompt, or retrieval configuration changes.

## Why Dynatrace + Red Hat Ansible Together

- Dynatrace provides deep runtime context and high-fidelity problem detection.
- Ansible turns intent into consistent, repeatable automation across deployment and operations.
- EDA connects detections to actions, reducing mean time to remediation.
- The combined platform supports reliable AI operations with less manual intervention.

## Lab Outcomes

At the end of this lab, you will have implemented an end-to-end flow from deployment to autonomous remediation for an AI-enabled application.

Continue to [Prerequisites](prerequisites.md).
