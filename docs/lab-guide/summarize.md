# Summarize

This workshop walked through an end-to-end AI operations lifecycle using Dynatrace and Red Hat AAP.

## What You Accomplished

- Provisioned Red Hat AAP containerized on RHEL 9.
- Deployed Dynatrace components, including app/configuration integrations, EdgeConnect, and OneAgent.
- Deployed the easyTravel AI Travel Advisor stack using Ansible-orchestrated Podman automation.
- Observed AI workload behavior and compared outcomes after controlled runtime changes.
- Executed autonomous remediation where Dynatrace detections triggered EDA recovery actions.
- Configured AI coding agents (GitHub Copilot) with Dynatrace `dtctl` skills and the Ansible MCP Server.
- Delegated observability queries and automation workflows to AI agents using natural language.
- Executed end-to-end "analyze and remediate" tasks through conversational delegation.

## What You Learned

- How to combine observability and automation for reliable AI service delivery.
- How event-driven operations reduce response time and manual toil.
- How to validate model and retrieval configuration changes with telemetry-backed evidence.
- How AI coding agents lower the skill barrier for observability investigations and automation execution.
- How conversational delegation collapses multi-system workflows from minutes into seconds while maintaining human oversight.
- How tool approval patterns preserve safety and accountability when AI agents execute state-changing operations.

## The Delegation Advantage

The Delegate phase demonstrated a fundamental shift in how platform teams interact with observability and automation platforms:

**From Manual to Conversational**

Instead of navigating UIs, writing DQL queries by hand, or locating job templates across AAP projects, engineers express intent in natural language. AI agents handle the mechanical translation between systems.

**From Sequential to Composed**

A single delegated request—"analyze models, pick the fastest, deploy it"—triggers queries to Dynatrace, reasoning over results, job launches in AAP, and verification checks. What once required context-switching across multiple tools now flows through one conversational interface.

**From Specialized to Accessible**

Deep expertise in DQL syntax, AAP API patterns, or EDA rulebook structures is no longer a prerequisite. Domain experts can investigate and act using the same natural language they use to describe problems to teammates.

**Transparency and Control**

Every tool call remains visible and requires approval before execution. Delegated automation is auditable through the same AAP job logs, Dynatrace traces, and chat transcripts teams already use for troubleshooting and compliance.

## Recommended Next Steps

- Expand detection rules for additional AI quality and cost controls.
- Add policy-driven approvals for high-impact automation paths.
- Integrate this pattern into broader platform engineering workflows.
- Extend AI agent capabilities by adding MCP servers for additional systems (ServiceNow, Kubernetes, GitHub).
- Build custom `dtctl` skills for domain-specific observability patterns in your organization.
- Define delegation boundaries: identify which workflows should remain human-driven versus agent-assisted.

Continue to [Clean](clean.md).
