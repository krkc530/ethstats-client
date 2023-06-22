#!/bin/sh

cd /ethstats-client
pm2 start app.json
tail -f /home/node/.pm2/logs/besu-private-out-0.log