#!/bin/bash

volumename=$(printf '%s' 'Enter the name of the volume: ' >&2; read x && printf '%s' "$x")
volumenamespace=$(printf '%s' 'Enter Desired Kubernetes Namespace for the volume: ' >&2; read x && printf '%s' "$x")
volumesize=$(printf '%s' 'Size in GiB: ' >&2; read x && printf '%s' "$x")

size_bytes=$(echo "$volumesize * 1024 * 1024 * 1024" | bc | awk '{printf "%d", $0}') 
size_mi=$(echo "$volumesize * 1024" | bc | awk '{printf "%d", $0}') 

cat <<EOF > storage.yaml
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  labels:
    longhornvolume: $volumename  # Set name
  name: $volumename              ## Edit to match name
  namespace: longhorn-system
spec:
  numberOfReplicas: 2
  disableFrontend: false
  frontend: blockdev
  size: "$size_bytes"                     
  staleReplicaTimeout: 30
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $volumename               # Edit to match name
spec:
  capacity:
    storage: ${size_mi}Mi                     # Edit to match size
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: longhorn
  csi:
    driver: driver.longhorn.io
    fsType: ext4
    volumeAttributes:
      numberOfReplicas: '2'
      staleReplicaTimeout: '30'
    volumeHandle: $volumename
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $volumename               # Edit to match name
  namespace: $volumenamespace            # Edit to match namespace
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: ${size_mi}Mi                    # Edit to match size
  volumeName: $volumename         # Edit to match volume name
  storageClassName: longhorn
EOF