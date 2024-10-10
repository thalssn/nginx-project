#!/bin/bash

LOG_DIR=~/nginx_project/logs

if systemctl is-active --quiet nginx; then
	STATUS_MESSAGE="$(date '+%d-%M-%Y %H:%M:%S') O serviço nginx está em execução - nginx - ONLINE"
	echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_online.log"
	echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_status.log"
else
	STATUS_MESSAGE="$(date '+%d-%m-%Y %H:%M:%S') O serviço nginx não está em execução -  nginx - OFFLINE"
	echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_offline.log"
	echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_status.log"
fi
