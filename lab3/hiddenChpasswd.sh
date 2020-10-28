#!/bin/bash

##
# Change password preserving 'last change date'
# R/W access to /etc/shadow required
##

USER="$1"
PASSWORD_HASH=$(openssl passwd -crypt "$2")

PASSWD_CHANGED=$(awk -v PASSWORD_HASH=$PASSWORD_HASH -v USER=$USER 'BEGIN { FS=":"; OFS=":" } {if ($1 == USER) {$2=PASSWORD_HASH} print }' /etc/shadow)
echo "$PASSWD_CHANGED" > /etc/shadow

echo "Don't forget to clear the history"
echo " bash: 'history -c'"
echo " sh:   'history -c'"
echo " fish: 'history clear'"

