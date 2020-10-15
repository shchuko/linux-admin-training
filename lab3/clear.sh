#!/bin/bash

userdel "u2"
userdel "u1"
userdel "user"

groupdel "g1"

rm -rf "/home/u1"
rm -rf "/home/u2"
rm -rf "/home/user"

rm -rf "/home/test13"
rm -rf "/home/test14"
rm -rf "/home/test15"

rm "work3.log"

rm "/etc/skel/readme.txt"

rm "/var/spool/mail/u1"
rm "/var/spool/mail/u2"
rm "/var/spool/mail/user"

