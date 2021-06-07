#!/bin/sh

PUID=${PUID:-82}
PGID=${PGID:-82}

groupmod -o -g "$PGID" www-data
usermod -o -u "$PUID" www-data