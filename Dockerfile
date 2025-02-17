## Dockerfile for eth-net-intelligence-api (build from git).
##
## Build via:
#
# `docker build -t ethnetintel:latest .`
#
## Run via:
#
# `docker run -v <path to app.json>:/home/ethnetintel/eth-net-intelligence-api/app.json ethnetintel:latest`
#
## Make sure, to mount your configured 'app.json' into the container at
## '/home/ethnetintel/eth-net-intelligence-api/app.json', e.g.
## '-v /path/to/app.json:/home/ethnetintel/eth-net-intelligence-api/app.json'
## 
## Note: if you actually want to monitor a client, you'll need to make sure it can be reached from this container.
##       The best way in my opinion is to start this container with all client '-p' port settings and then 
#        share its network with the client. This way you can redeploy the client at will and just leave 'ethnetintel' running. E.g. with
##       the python client 'pyethapp':
##
#
# `docker run -d --name ethnetintel \
# -v /home/user/app.json:/home/ethnetintel/eth-net-intelligence-api/app.json \
# -p 0.0.0.0:30303:30303 \
# -p 0.0.0.0:30303:30303/udp \
# ethnetintel:latest`
#
# `docker run -d --name pyethapp \
# --net=container:ethnetintel \
# -v /path/to/data:/data \
# pyethapp:latest`
#
## If you now want to deploy a new client version, just redo the second step.

FROM node:lts-alpine AS builder


WORKDIR /ethstats-client
COPY ["package.json", "package-lock.json*", "./"]
RUN npm ci --only=production
COPY --chown=node:node . .

FROM node:lts-alpine
RUN apk add dumb-init
WORKDIR /ethstats-client
COPY --chown=node:node --from=builder /ethstats-client .
RUN chmod +x start.sh
RUN npm i -g pm2
# RUN apk add --no-cache curl
RUN chmod -R 777 /ethstats-client

USER node
ENTRYPOINT [ "/ethstats-client/start.sh" ]
