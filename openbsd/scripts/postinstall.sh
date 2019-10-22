#!/bin/sh
#
# Add to this file if you need more stuff done.

set -e

## Set CDN installurl (Cloudflare mirror), for syspatch and pkg_add
echo "https://cloudflare.cdn.openbsd.org/pub/OpenBSD" > /etc/installurl
