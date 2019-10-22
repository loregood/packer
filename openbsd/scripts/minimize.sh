#!/bin/sh
#
# Fill all active partions with zeros for a smaller box size.

set -e

## Find all the active partitions, except swap (none)
partitions=$(/usr/bin/awk '{print $2}' /etc/fstab |grep -v none)

## For each partition zero out the remaining space with an empty file
for partition in ${partitions}; do
  /bin/dd if=/dev/zero of=${partition}/EMPTY bs=1M || true
  /bin/rm -f ${partition}/EMPTY
done

## Make sure changes are written to disk (flush cache).
/bin/sync
