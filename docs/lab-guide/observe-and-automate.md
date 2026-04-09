# Observe and Automate

In this phase, you drive the application with prompts, observe behavior in Dynatrace AI observability views, and automate controlled runtime changes through deployment workflows.

## Objectives

- Exercise the travel advisor with realistic prompts.
- Observe workload behavior and AI response characteristics.
- Automate changes to model selection, temperature, and RAG instructions.
- Compare response quality and runtime signals after each change.

## Step 1: Generate Baseline AI Traffic

- Access the AI Travel Advisor interface.
- Submit a consistent set of prompts for baseline behavior.
- Capture expected response style, latency, and relevance.

## Step 2: Observe in Dynatrace

Use the AI observability views to inspect:

- Request and response traces
- Model behavior indicators
- Throughput and latency trends
- Any anomalies affecting quality or performance

## Step 3: Automate Configuration Changes

Apply controlled updates via AAP deployment automation:

- Change active model selection
- Adjust temperature parameters
- Update retrieval instructions and guardrails

## Step 4: Compare Results

- Run the same prompt set after each change.
- Compare answer consistency, speed, and contextual relevance.
- Determine which settings improve outcomes for your scenario.

## Validation

- [ ] Baseline and post-change observations are documented.
- [ ] Each automated change is traceable in AAP job history.
- [ ] Dynatrace clearly reflects behavior differences across changes.

Continue to [Remediate](remediate.md).
