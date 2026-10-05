# K9s plugins

`default.nix` merges the CNPG and Velero declarations and generates `plugins.yaml`.
It also installs the Velero CLI. Velero commands use the selected K9s context.

## Velero shortcuts

| View | Shortcut | Action |
| --- | --- | --- |
| Backups | Shift-D | Details |
| Backups | Shift-L | Logs |
| Backups | Shift-R | Restore; optionally name the restore and map namespaces |
| Backups | Shift-X | Delete backup and associated data through Velero |
| Restores | Shift-D | Details |
| Restores | Shift-L | Logs |
| Schedules | Shift-B | Run a backup using the schedule's template |
| Schedules | Shift-P | Pause |
| Schedules | Shift-U | Unpause |
| Namespaces | Shift-B | Back up the namespace; choose filesystem or CSI snapshot mode |
| PVCs | Shift-B | Back up the selected volume's files through a running pod |
| PVCs | Shift-S | Back up the selected PVC using CSI snapshots and data movement |

Use Velero's `backups`, `restores`, and `schedules` resources for the corresponding
actions. Namespace and PVC actions prompt for the Velero installation namespace
(default `velero`), separately from the workload namespace. Backup names default
to the selected resource name plus a UTC timestamp.

Filesystem backups require a filesystem-mode PVC mounted by a running pod and a
configured Velero node agent and backup storage location. If several pods mount
the PVC, the command asks which one to use. CSI backups require a snapshot-capable
driver, an appropriate VolumeSnapshotClass, and Velero CSI data movement setup.

PVC actions temporarily label the selected resources. Filesystem backups also
temporarily set the mounting pod's volume-selection annotation. They wait for the
backup and then restore this metadata. If interrupted while the backup is still
running (or its status cannot be retrieved), they retain the metadata and print
cleanup instructions so the server-side backup can finish selecting its data.

Details and logs use a pager. Other command output remains visible until Enter.
