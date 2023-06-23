#!/bin/sh

cd /ethstats-client
pm2 start app.json
tail -f /home/node/.pm2/logs/node-app-out-0.log