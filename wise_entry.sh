#!/bin/sh
if [ "$1" = 'wise' ]; then
    exec node wiseService.js -c /data/enrichment/wise/wiseService.ini
else
    exec "$@"
fi