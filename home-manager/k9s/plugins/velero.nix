{pkgs}: let
  runner = pkgs.writeShellApplication {
    name = "k9s-velero";
    runtimeInputs = with pkgs; [velero kubectl jq coreutils less];
    text = builtins.readFile ./velero.sh;
  };
  plugin = shortCut: scopes: description: action: confirm: {
    inherit shortCut scopes description confirm;
    command = "${runner}/bin/k9s-velero";
    background = false;
    override = true;
    args = [action "$CONTEXT" "$NAMESPACE" "$NAME" "$RESOURCE_GROUP"];
  };
in {
  velero-backup-describe = plugin "Shift-D" ["backups"] "Velero backup details" "backup-describe" false;
  velero-backup-logs = plugin "Shift-L" ["backups"] "Velero backup logs" "backup-logs" false;
  velero-backup-restore = plugin "Shift-R" ["backups"] "Restore Velero backup" "backup-restore" true;
  velero-backup-delete = plugin "Shift-X" ["backups"] "Delete Velero backup and data" "backup-delete" true;
  velero-restore-describe = plugin "Shift-D" ["restores"] "Velero restore details" "restore-describe" false;
  velero-restore-logs = plugin "Shift-L" ["restores"] "Velero restore logs" "restore-logs" false;
  velero-schedule-backup = plugin "Shift-B" ["schedules"] "Run Velero schedule now" "schedule-backup" true;
  velero-schedule-pause = plugin "Shift-P" ["schedules"] "Pause Velero schedule" "schedule-pause" true;
  velero-schedule-unpause = plugin "Shift-U" ["schedules"] "Resume Velero schedule" "schedule-unpause" true;
  velero-namespace-backup = plugin "Shift-B" ["namespaces"] "Velero namespace backup" "namespace-backup" true;
  velero-pvc-filesystem = plugin "Shift-B" ["persistentvolumeclaims"] "Velero PVC filesystem backup" "pvc-filesystem" true;
  velero-pvc-snapshot = plugin "Shift-S" ["persistentvolumeclaims"] "Velero PVC snapshot to object storage" "pvc-snapshot" true;
}
