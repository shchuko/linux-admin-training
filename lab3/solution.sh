#!/bin/bash

printTask() {
	echo "-----------"
	echo "- Task $1 -"
	[[ $# -eq 2 ]] && echo "$2"
	echo "-----------"
}

printTask 1 "list users with ids"
# man passwd.5
LOG="$PWD/work3.log"
awk -F":" '{ print("user", $1, "has id", $3) }' /etc/passwd > "$LOG"

printTask 2 "root passwd last change date"
passwd -S root | cut -d" " -f3 >> "$LOG"

printTask 3 "save group names"
# man group.5
awk -F: 'ORS="," {print $1}' /etc/group >> "$LOG"


printTask 4 "autoadd readme.txt to home dirs"
README_SKEL_PATH="/etc/skel/readme.txt"
echo "Be careful!" > "$README_SKEL_PATH"

printTask 5 "u1 create"
U1_NAME="u1"
U1_PASSWORD="12345678"
useradd "$U1_NAME" -p $(openssl passwd -crypt "$U1_PASSWORD")

printTask 6 "g1 create"
G1_NAME="g1"
groupadd "$G1_NAME"

printTask 7 "add u1 to g1"
usermod -a -G "$G1_NAME" "$U1_NAME"

printTask 8 "id u1"
id "$U1_NAME" >> "$LOG"

printTask 9 "add user to g1"
USER_NAME="user"
USER_PASSWORD="12345678"
useradd "$USER_NAME" -p $(openssl passwd -crypt "$USER_PASSWORD")
usermod -a -G "$G1_NAME" "$USER_NAME"

printTask 10 "print g1 members"
awk -F":" '$1 == "g1" {print $1}' /etc/group >> "$LOG"

printTask 11 "user usershell mc"
SHELL_PATH="/usr/bin/mc"
usermod -s "$SHELL_PATH" "$USER_NAME"

printTask 12 "u2 create"
U2_NAME="u2"
U2_PASSWORD="87654321"
useradd "$U2_NAME" -p $(openssl passwd -crypt "$U2_PASSWORD")

printTask 13 "log copy"
TEST13="/home/test13"
LOG_COPY1="$TEST13/work3-1.log"
LOG_COPY2="$TEST13/work3-2.log"
mkdir "$TEST13"
cp "$LOG" "$LOG_COPY1"
cp "$LOG" "$LOG_COPY2"

printTask 14 "edit privileges"
usermod -a -G "$U1_NAME" "$U2_NAME"
chown "$U1_NAME":"$U1_NAME" "$TEST13" -R
chmod 640 "$TEST13" -R
chmod 550 "$TEST13" 

printTask 15 "edit privileges 2"
TEST14="/home/test14"
mkdir "$TEST14"
chmod 1777 "$TEST14"

printTask 16 "nano!"
NANO_SRC="/bin/nano"
NANO_CPY="$TEST14/nano"
cp "$NANO_SRC" "$NANO_CPY"
chmod 6555 "$NANO_CPY"

printTask 17 "secret file"
TEST15="/home/test15"
SECRET_FILE="$TEST15/secret_file"
mkdir "$TEST15"
echo "Oh, it's a secret!" > "$SECRET_FILE"
chmod 111 "$TEST15"
chmod 444 "$SECRET_FILE"

