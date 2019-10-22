#!/bin/sh
#
# Fill all partions with zeros for a smaller box size.

set -e

## /
/bin/dd if=/dev/zero of=/EMPTY bs=1M || true
/bin/rm -f /EMPTY

## /home
/bin/dd if=/dev/zero of=/home/EMPTY bs=1M || true
/bin/rm -f /home/EMPTY

## /tmp
/bin/dd if=/dev/zero of=/tmp/EMPTY bs=1M || true
/bin/rm -f /tmp/EMPTY

## /usr
/bin/dd if=/dev/zero of=/usr/EMPTY bs=1M || true
/bin/rm -f /usr/EMPTY

## /usr/X11R6
/bin/dd if=/dev/zero of=/usr/X11R6/EMPTY bs=1M || true
/bin/rm -f /usr/X11R6/EMPTY

## /usr/local
/bin/dd if=/dev/zero of=/usr/local/EMPTY bs=1M || true
/bin/rm -f /usr/local/EMPTY

## /usr/obj
/bin/dd if=/dev/zero of=/usr/obj/EMPTY bs=1M || true
/bin/rm -f /usr/obj/EMPTY

## /usr/src
/bin/dd if=/dev/zero of=/usr/src/EMPTY bs=1M || true
/bin/rm -f /usr/src/EMPTY

## /var
/bin/dd if=/dev/zero of=/var/EMPTY bs=1M || true
/bin/rm -f /var/EMPTY

## Make sure changes are written to disk (flush cache)
/bin/sync
