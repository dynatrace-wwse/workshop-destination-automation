# Syncing Repository Changes to the Deployed Instance

## Scenario

You updated the repo (for example with `git pull`), but the deployed application still behaves like the old version. For example, nginx may still be published on an old port after the repo was changed.

A `git pull` only updates the clone in `~/workshop-destination-automation` (`~` is the home directory of the workshop user). The deployment doesn't run from that clone. AAP jobs run from two separate copies of the files, and neither one updates automatically:

| Copy | Location | Contains | Used for |
|---|---|---|---|
| Git clone | `~/workshop-destination-automation` | Everything | Source of truth, where you pull |
| AAP project copy | `/opt/ansible/aap/controller/projects/destination-automation` | `ansible/` content, plus `dynatrace/config/` | The playbooks, roles and inventory that AAP job templates run (manual project) |
| Service-account runtime copy | `/home/aap-service-account/destination-automation` | `app/` and `dynatrace/config/` | The app source, Containerfile and compose files used to build and deploy |

If either copy is stale, a redeploy from AAP uses the old files even though the clone is current.

## Sequence of operations

1. Pull the latest changes into the git clone.
2. Sync the runtime copy (`app/`, `dynatrace/config`).
3. Sync the AAP project copy (`ansible/`, `dynatrace/config`).
4. Re-run the relevant job template(s) in AAP.

Do not run `configure_aap.yml` (the full `aap_config` role) just to sync files. It also re-applies controller objects (credentials, projects, job templates, users), which can overwrite changes made manually in the AAP UI.

## Steps and commands

### 1. Pull the latest changes

```bash
cd ~/workshop-destination-automation
git fetch --all --prune
git log --oneline HEAD..origin/main    # preview incoming commits
git pull --ff-only
```

### 2. Sync the service-account runtime copy

```bash
cd ~/workshop-destination-automation/ansible
ansible-playbook deploy/playbooks/sync_runtime_base_dir.yml -e aap_deploy_mode=local
```

This runs `rsync -a --delete` for `app/` and `dynatrace/config`, then sets ownership to `aap-service-account`.

### 3. Sync the AAP project copy

There is no playbook for this step. Use rsync directly.

```bash
SRC=~/workshop-destination-automation
DEST=/opt/ansible/aap/controller/projects/destination-automation

# Preview first (-n = dry run). Review the list, especially any deletions ("*deleting").
sudo rsync -an --delete --itemize-changes --exclude /dynatrace $SRC/ansible/ $DEST/
sudo rsync -an --delete --itemize-changes $SRC/dynatrace/config/ $DEST/dynatrace/config/

# Apply
sudo rsync -a --delete --exclude /dynatrace $SRC/ansible/ $DEST/
sudo rsync -a --delete $SRC/dynatrace/config/ $DEST/dynatrace/config/
```

Notes:
- `--exclude /dynatrace` on the first command stops `--delete` from wiping `dynatrace/config`. That directory is synced by the second command.
- The destination should be owned by the workshop user (the AAP install user). Verify after syncing:
  ```bash
  sudo find $DEST ! -user "$USER"
  ```
  No output means ownership is correct.
- Confirm there are no remaining differences by re-running the dry run. It should print nothing.

### 4. Re-run the job template in AAP

Launch the relevant template from the AAP UI (for example the deploy or build-images template). Manual projects need no project sync in the UI. The next job picks up the new files.

### 5. Verify

```bash
podman ps --format '{{.Names}} {{.Ports}}'
ss -ltnp | grep -E ':(80|81)\b'
curl -s http://localhost:80/health
```

## Which steps do I need?

| What changed in the repo | Sync runtime copy (step 2) | Sync AAP project copy (step 3) |
|---|---|---|
| `app/` (code, Containerfile, compose, nginx) | Yes | No |
| `dynatrace/config/` | Yes | Yes |
| `ansible/` playbooks, roles, inventories, `group_vars` | No | Yes |
| Not sure | Do both | Do both |

## Gotchas

- **Old containers can linger.** If a setting such as a published port changed, stop or remove the old container so the new one can bind. Otherwise the old one keeps running or the deploy fails.
- **Privileged ports.** Rootless Podman publishing a port below 1024 (such as 80) needs `net.ipv4.ip_unprivileged_port_start` set to that port or lower.
- **`--delete` removes extra files.** Anything that exists only in a destination directory is removed. That includes local edits made directly in the project or runtime copies. Make changes in the repo and sync them.
- **Don't use `configure_aap.yml` to sync files.** It reconfigures AAP objects and can overwrite manual UI changes.