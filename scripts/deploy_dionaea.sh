#!/bin/bash

URL=$1
DEPLOY=$2
ARCH=$3
SERVER=$(echo ${URL} | awk -F/ '{print $3}')
VERSION=1.9
TAGS=""

echo 'Creating docker-compose.yml...'
cat << EOF > ./docker-compose.yml
version: '3'
services:
  dionaea:
    image: stingar/dionaea${ARCH}:${VERSION}
    restart: always
    volumes:
      - configs:/etc/dionaea/
    ports:
      - "21:21"
      - "23:23"
      - "69:69"
      - "80:80"
      - "123:123"
      - "135:135"
      - "443:443"
      - "445:445"
      - "1433:1433"
      - "1723:1723"
      - "1883:1883"
      - "1900:1900"
      - "3306:3306"
      - "5000:5000"
      - "5060:5060"
      - "5061:5061"
      - "11211:11211"
      - "27017:27017"
    env_file:
      - dionaea.env
volumes:
    configs:
EOF
echo 'Done!'
echo 'Creating dionaea.env...'
cat << EOF > dionaea.env
# This can be modified to change the default setup of the unattended installation

DEBUG=false

# IP Address of the honeypot
# Leaving this blank will default to the docker container IP
IP_ADDRESS=

CHN_SERVER=${URL}
DEPLOY_KEY=${DEPLOY}

# Network options
LISTEN_ADDRESSES=0.0.0.0
LISTEN_INTERFACES=eth0


# Service options
# blackhole, epmap, ftp, http, memcache, mirror, mongo, mqtt, mssql, mysql, pptp, sip, smb, tftp, upnp
SERVICES=(blackhole epmap ftp http memcache mirror mongo mqtt pptp sip smb tftp upnp)

DIONAEA_JSON=/etc/dionaea/dionaea.json

# Logging options
HPFEEDS_ENABLED=true
FEEDS_SERVER=${SERVER}
FEEDS_SERVER_PORT=10000

# Comma separated tags for honeypot
TAGS=${TAGS}

# A specific "personality" directory for the dionaea honeypot may be specified
# here. These directories can include custom dionaea.cfg and service configurations
# files which can influence the attractiveness of the honeypot.
PERSONALITY=""
EOF
echo 'Done!'
echo ''
echo ''
echo 'Type "docker-compose ps" to confirm your honeypot is running'
echo 'You may type "docker-compose logs" to get any error or informational logs from your honeypot'
