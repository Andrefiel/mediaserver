#!/bin/bash

# Atualiza o Ubuntu
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

# Cria a pasta docker na raiz
sudo mkdir /docker

# Instala o Docker e Docker-Compose
sudo apt install docker.io docker-compose -y

# Acessa a pasta docker
cd /docker

# Cria o arquivo docker-compose.yml
sudo touch docker-compose.yml

# Escreve a configuração do arquivo docker-compose.yml
cat << EOF | sudo tee docker-compose.yml

version: '3'

services:
  plex:
    image: linuxserver/plex:arm32v7-latest
	  container_name: plex
	  restart: unless-stopped
	  ports:
	    - 32400:32400/tcp
	    - 3005:3005/tcp
	    - 8324:8324/tcp
	    - 32469:32469/tcp
	    - 1900:1900/udp
	    - 32410:32410/udp
	    - 32412:32412/udp
	    - 32413:32413/udp
	    - 32414:32414/udp
	  environment:
	    - TZ=${DOCKER_TIME_ZONE}
	    - PUID=${PUID}
	    - PGID=${PGID}
	  volumes:
	    - ${DOCKER_APPDATA_PATH}/plex:/config
	    - ${DATA_PATH}:/data

  jellyfin:
	  image: jellyfin/jellyfin:latest-arm32v7
	  container_name: jellyfin
	  restart: unless-stopped
	  ports:
	    - "8096:8096"
	  environment:
	    - TZ=${DOCKER_TIME_ZONE}
	    - PUID=${PUID}
	    - PGID=${PGID}
	  volumes:
	    - ${DOCKER_APPDATA_PATH}/jellyfin:/config
	    - ${DATA_PATH}:/data

  nextcloud:
    image: linuxserver/nextcloud:arm32v7-latest
    container_name: nextcloud
    restart: unless-stopped
    ports:
      - 80:80/tcp
      - 443:443/tcp
    environment:
      - TZ=${DOCKER_TIME_ZONE}
      - PUID=${PUID}
      - PGID=${PGID}
    volumes:
      - ${DOCKER_APPDATA_PATH}/nextcloud:/config
      - ${DATA_PATH}:/data

  db:
    image: mariadb:latest
    container_name: db
    restart: unless-stopped
    environment:
      - TZ=${DOCKER_TIME_ZONE}
      - MYSQL_ROOT_PASSWORD=123mudar
      - MYSQL_DATABASE=media
      - MYSQL_USER=base
			- MYSQL_PASSWORD=123mudar
		volumes:
			- ${DOCKER_APPDATA_PATH}/db:/var/lib/mysql

	radarr:
		image: linuxserver/radarr:arm32v7-latest
		container_name: radarr
		restart: unless-stopped
		ports:
			- "7878:7878"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/radarr:/config
			- ${DATA_PATH}:/data

	sonarr:
		image: linuxserver/sonarr:arm32v7-latest
		container_name: sonarr
		restart: unless-stopped
		ports:
			- "8989:8989"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
		- ${DOCKER_APPDATA_PATH}/sonarr:/config
		- ${DATA_PATH}:/data

	lidarr:
		image: linuxserver/lidarr:arm32v7-latest
		container_name: lidarr
		restart: unless-stopped
		ports:
			- "8686:8686"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/lidarr:/config
			- ${DATA_PATH}:/data

	jackett:
		image: linuxserver/jackett:arm32v7-latest
		container_name: jackett
		restart: unless-stopped
		ports:
			- "9177:9117"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/jackett:/config
			- ${DATA_PATH}:/data

	airsonic:
		image: linuxserver/airsonic:arm32v7-latest
		container_name: airsonic
		restart: unless-stopped
		ports:
			- "4040:4040"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/airsonic:/config
			- ${DATA_PATH}:/data

	bazarr:
		image: linuxserver/bazarr:arm32v7-latest
		container_name: bazarr
		restart: unless-stopped
		ports:
			- "6767:6767"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/bazarr:/config
			- ${DATA_PATH}:/data

	cockpit:
		image: linuxserver/cockpit:arm32v7-latest
		container_name: cockpit
		restart: unless-stopped
		environment:
				- TZ=${DOCKER_TIME_ZONE}
		ports:
				- 2022:22/tcp

	heimdall:
		image: linuxserver/heimdall:arm32v7-latest
		container_name: heimdall
		restart: unless-stopped
		ports:
			- "80:80"
			- "443:443"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/heimdall:/config

	uptime-kuma:
		image: uptimekuma/uptime-kuma:arm32v7-latest
		container_name: uptime-kuma
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
		ports:
			- 3030:3030/tcp

#nginx-proxy-manager:
#image: jc21/nginx-proxy-manager:arm32v7-latest
#container_name: nginx-proxy-manager
#restart: unless-stopped
#ports:
#- 80:80/tcp
#- 81:81/tcp
#- 443:443/tcp
#environment:
#- TZ=${DOCKER_TIME_ZONE}
#- PUID=${PUID}
#- PGID=${PGID}
#volumes:
#- ${DOCKER_APPDATA_PATH}/nginx-proxy-manager/data:/data
#3- ${DOCKER_APPDATA_PATH}/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
#- ${DOCKER_APPDATA_PATH}/nginx-proxy-manager/nginx:/etc/nginx

	grafana:
		image: grafana/grafana:latest-armhf
		container_name: grafana
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
		ports:
			- 3000:3000/tcp

#portainer:
#image: portainer/portainer-ce:arm
#container_name: portainer
#restart: unless-stopped
#environment:
#- TZ=${DOCKER_TIME_ZONE}
#ports:
#- 9000:9000/tcp
#volumes:
#- /var/run/docker.sock:/var/run/docker.sock
#- ${DOCKER_APPDATA_PATH}/portainer:/data

	dozzle:
		image: amir20/dozzle:arm32v7-latest
		container_name: dozzle
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
		ports:
			- 8888:8080/tcp
		volumes:
			- /var/run/docker.sock:/var/run/docker.sock

	filebrowser:
		image: filebrowser/filebrowser:armhf
		container_name: filebrowser
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			 PUID=${PUID}
			 PGID=${PGID}
		ports:
			- 8080:80/tcp
		volumes:
			- ${DOCKER_APPDATA_PATH}/filebrowser:/config
			- ${DATA_PATH}:/data

	tautulli:
		image: linuxserver/tautulli:arm32v7-latest
		container_name: tautulli
		restart: unless-stopped
		ports:
			- "32833:8181"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/tautulli:/config
			- ${DATA_PATH}:/data

	ombi:
		image: linuxserver/ombi:arm32v7-latest
		container_name: ombi
		restart: unless-stopped
		ports:
			- "3579:3579"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/ombi:/config
			- ${DATA_PATH}:/data

	prowlarr:
		image: linuxserver/prowlarr:arm32v7-latest
		container_name: prowlarr
		restart: unless-stopped
		ports:
			- "9696:9696"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/prowlarr:/config
			- ${DATA_PATH}:/data

	netdata:
		image: netdata/netdata:armhf-latest
		container_name: netdata
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
		ports:
			- 19999:19999/tcp
		cap_add:
			- SYS_PTRACE
			- SYS_ADMIN
		security_opt:
			- apparmor:unconfined
		volumes:
			- /proc:/host/proc:ro
			- /sys:/host/sys:ro
			- /var/run/docker.sock:/var/run/docker.sock

	influxdb:
		image: arm32v7/influxdb:latest
		container_name: influxdb
		restart: unless-stopped
		ports:
			- "8086:8086"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- INFLUXDB_DB=db
			- INFLUXDB_ADMIN_USER=admin
			- INFLUXDB_ADMIN_PASSWORD=123mudar
			- INFLUXDB_USER=base
			- INFLUXDB_USER_PASSWORD=123mudar
		volumes:
			- ${DOCKER_APPDATA_PATH}/influxdb:/var/lib/influxdb

	jdownloader:
		image: jlesage/jdownloader-2:armhf-latest
		container_name: jdownloader
		restart: unless-stopped
		ports:
			- "5800:5800"
			- "3129:3129"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
			- JAVA_OPTS="-Xmx512M -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"
		volumes:
			- ${DOCKER_APPDATA_PATH}/jdownloader:/config
			- ${DATA_PATH}:/data

	transmission:
		image: linuxserver/transmission:arm32v7-latest
		container_name: transmission
		restart: unless-stopped
		ports:
			- "9091:9091"
			- "51413:51413/tcp"
			- "51413:51413/udp"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
			- TRANSMISSION_WEB_HOME=/combustion-release/ #optional
		volumes:
			- ${DOCKER_APPDATA_PATH}/transmission:/config
			- ${DATA_PATH}:/data

	handbrake:
		image: jlesage/handbrake:armhf-latest
		container_name: handbrake
		restart: unless-stopped
		ports:
			- "5800:5800"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		volumes:
			- ${DOCKER_APPDATA_PATH}/handbrake:/config
			- ${DATA_PATH}:/data

	wg-easy:
		image: wg-easy:latest
		container_name: wg-easy
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
		ports:
			- 51820:51820/udp
		volumes:
			- ${DOCKER_APPDATA_PATH}/wg-easy:/config

	overseerr:
		image: overseerr/overseerr:arm32v7-latest
		container_name: overseerr
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- PUID=${PUID}
			- PGID=${PGID}
		ports:
			- "5055:5055"
		volumes:
			- ${DOCKER_APPDATA_PATH}/overseerr:/config
			- ${DATA_PATH}:/data

	glpi:
		image: glpi/glpi:arm32v7-latest
		container_name: glpi
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
		ports:
			- 81320:80/tcp
			- 81321:443/tcp
		volumes:
			- ${DOCKER_APPDATA_PATH}/glpi:/var/www/glpi

	zabbix-server-mysql:
		image: zabbix/zabbix-server-mysql:alpine-5.0-latest
		container_name: zabbix-server-mysql
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- MYSQL_DATABASE=zabbix
			- MYSQL_USER=zabbix
			- MYSQL_PASSWORD=zabix
			- MYSQL_ROOT_PASSWORD=123mudar
		ports:
			- 10051:10051/tcp
		volumes:
			- ${DOCKER_APPDATA_PATH}/zabbix-server-mysql/data:/var/lib/mysql

	zabbix-web-nginx-mysql:
		image: zabbix/zabbix-web-nginx-mysql:alpine-5.0-latest
		container_name: zabbix-web-nginx-mysql
		restart: unless-stopped
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- DB_SERVER_HOST=zabbix-server-mysql
			- MYSQL_DATABASE=zabbix
			- MYSQL_USER=zabbix
			- MYSQL_PASSWORD=zabix
			- MYSQL_ROOT_PASSWORD=123mudar
		volumes:
			- ${DOCKER_APPDATA_PATH}/zabbix-web-nginx-mysql/html:/usr/share/zabbix
			- ${DOCKER_APPDATA_PATH}/zabbix-web-nginx-mysql/nginx.conf:/etc/nginx/conf.d/default.conf

	pi-hole:
		image: pihole/pihole:latest-armhf
		container_name: pi-hole
		ports:
			- "53:53/tcp"
			- "53:53/udp"
			- "67:67/tcp"
			- "67:67/udp"
			- "80:80/tcp"
			- "443:443/tcp"
		environment:
			- TZ=${DOCKER_TIME_ZONE}
			- WEBPASSWORD=123mudar
		volumes:
			- ${DOCKER_APPDATA_PATH}/pi-hole/config:/etc/pihole/
			- ${DOCKER_APPDATA_PATH}/pi-hole/dnsmasq.d:/etc/dnsmasq.d/
		EOF

# Cria o arquivo .env
sudo touch .env

# Escreve a configuração do arquivo .env
cat << EOF | sudo tee .env

DOCKER_NETWORK_NAME = media
DOCKER_CONTAINER_PREFIX = media-orcl
DOCKER_TIME_ZONE = America/Fortaleza
DOCKER_APPDATA_PATH = /mnt/externo/data
PUID = 1000
PGID = 1000

# Top-Level Location of Your Media and Incoming Data
DATA_PATH = /mnt/externo/data/media

# Plex
PLEX_CLAIM = 
PLEX_ADVERTISE_IP = http://localhost:32400/
PLEX_TRANSCODE_PATH = /docker/media/data/plex/transcode

# VPN
VPN_USERNAME = p#######
VPN_PASSWORD = ????????????????????
VPN_LAN_SUBNET = 10.0.0.0/24
EOF

```
