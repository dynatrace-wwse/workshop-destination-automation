# Dynatrace Authentication Requirements

This document lists the Dynatrace authentication pieces required by this workshop and the minimum values to provide in AAP credentials.

## 1. Dynatrace Platform Token (Monaco)

Use this token for Monaco configuration-as-code deployment.  This token is also used by Ansible roles that create Dynatrace configuration objects not handled by Monaco.

Reference: [https://docs.dynatrace.com/docs/deliver/configuration-as-code/monaco/guides/create-platform-token#create-a-platform-token](https://docs.dynatrace.com/docs/deliver/configuration-as-code/monaco/guides/create-platform-token#create-a-platform-token)

### Required scopes

| Purpose | Scopes |
|---|---|
| Access platform metadata like Dynatrace classic URLs and version information | `app-engine:apps:run`, `app-engine:apps:install` |
| Manage Settings 2.0 objects and all-users permission | `settings:objects:read`, `settings:objects:write` |
| View Settings 2.0 schemas | `settings:schemas:read` |
| Manage automation workflows | `automation:workflows:read`, `automation:workflows:write`, `automation:calendars:read`, `automation:calendars:write`, `automation:rules:read`, `automation:rules:write` |
| Access all automation workflows | `automation:workflows:admin` |
| Manage documents | `document:documents:read`, `document:documents:write`, `document:documents:delete`, `document:trash.documents:read`, `document:trash.documents:delete` |

## 2. Dynatrace OTLP API token

Used by the OpenTelemetry Collector export in workshop jobs.

Reference: [https://docs.dynatrace.com/docs/shortlink/otel-getstarted-otlpexport#authentication-export-to-activegate](https://docs.dynatrace.com/docs/shortlink/otel-getstarted-otlpexport#authentication-export-to-activegate)

| Scopes required |
|---|---|
| Traces: | openTelemetryTrace.ingest |
| Metrics: | metrics.ingest |
| Logs: | logs.ingest |

Provide in AAP credential fields:
- `DT_OTLP_ENDPOINT`
- `DT_OTLP_TOKEN`

Minimum token scopes must match the signals you export (metrics, traces, logs) in your Dynatrace tenant.

## 3. Dynatrace OAuth client credentials

Primarily used to deploy the EdgeConnect container on the AAP host.  This credential needs permissions to read, write, and manage EdgeConnects and their OAuth clients.

### Required scopes

| Purpose | Scopes |
|---|---|
| Manage EdgeConnect configurations | `app-engine:edge-connects:read`, `app-engine:edge-connects:write`, `app-engine:edge-connects:delete` |
| Manage EdgeConnect OAuth | `oauth2:clients:manage` |

Provide in AAP credential fields:
- `DT_OAUTH_CLIENT_ID`
- `DT_OAUTH_CLIENT_SECRET`
- `DT_OAUTH_ACCOUNT_URN`

## 4. Dynatrace OneAgent download credentials

Used by OneAgent deployment automation.

### Required scopes

| Purpose | Scopes |
|---|---|
| PaaS integration | `InstallerDownload`, `SupportAlert` |

Provide in AAP credential fields:
- `oneagent_environment_url`
- `oneagent_paas_token`

## Credential handling guidance

- Store credentials in AAP credential objects, not in plaintext files in the repo.
- Do not commit real tokens or client secrets.
- Rotate tokens/secrets regularly and after workshop events.