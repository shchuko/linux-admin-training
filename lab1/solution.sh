#!/bin/bash

TEST_DIR="$HOME/test"
LIST_FILE="$TEST_DIR/list"
ETC_DIR="/etc"

#1
mkdir "$TEST_DIR"

#2
ls -lA "$ETC_DIR" > "$LIST_FILE"

#3
find "$ETC_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l >> "$LIST_FILE"
find "$ETC_DIR" -mindepth 1 -maxdepth 1 -type f -name ".*" | wc -l >> "$LIST_FILE"

LINKS_DIR="$TEST_DIR/links"
LIST_FILE_HARDLINK="$LINKS_DIR/list_hlink"
LIST_FILE_SYMLINK="$LINKS_DIR/list_slink"
LIST_FILE_NEWNAME="${LIST_FILE}1"

#4
mkdir "$LINKS_DIR"

#5
ln "$LIST_FILE" "$LIST_FILE_HARDLINK"

#6
ln -s "$LIST_FILE" "$LIST_FILE_SYMLINK"

#7
echo -n "$LIST_FILE_HARDLINK hardlinks: "; ls -l "$LIST_FILE_HARDLINK" | awk '{print $2}'
echo -n "$LIST_FILE hardlinks: "; ls -l "$LIST_FILE" | awk '{print $2}'
echo -n "$LIST_FILE_SYMLINK hardlinks: "; ls -l "$LIST_FILE_SYMLINK" | awk '{print $2}'

#8 
cat "$LIST_FILE" | wc -l >> "$LIST_FILE_HARDLINK"

#9
printCmp() {
	if cmp --silent "$1" "$2"; then
		echo "YES"
	else
		echo "NO"
	fi
}

printCmp "$LIST_FILE_HARDLINK" "$LIST_FILE_SYMLINK"

#10
mv "$LIST_FILE" "$LIST_FILE_NEWNAME"

#11
printCmp "$LIST_FILE_HARDLINK" "$LIST_FILE_SYMLINK"

#12
#??

LIST_CONF_FILE="$HOME/list_conf"
LIST_D_FILE="$HOME/list_d"
LIST_CONF_D_FILE="$HOME/list_conf_d"

#13
find "$ETC_DIR" -mindepth 1 -type f -name "*.conf" 2>"/dev/null" >> "$LIST_CONF_FILE"

#14
find "$ETC_DIR" -mindepth 1 -maxdepth 1 -type d -name "*.d" | wc -l >> "$LIST_D_FILE"

#15
cat "$LIST_CONF_FILE" "$LIST_D_FILE" > "$LIST_CONF_D_FILE"

#16
TEST_SUB_DIR="$TEST_DIR/.sub/"
mkdir "$TEST_SUB_DIR"

#17
cp "$LIST_CONF_D_FILE" "$TEST_SUB_DIR/"

#18
cp -b "$LIST_CONF_D_FILE" "$TEST_SUB_DIR/"

#19 
ls -lRA "$TEST_DIR"

MAN_FILE="$HOME/man.txt"
MAN_FILES_PREFIX="man_"
MAN_DIR="$HOME/man.dir"
MAN_NEW_FILE="$MAN_DIR/man.txt"
MAN_PATCH_FILE="$MAN_DIR/man_patch"

#20
man man > "$MAN_FILE"

#21
BLOCK_SIZE=1024
split -b "$BLOCK_SIZE" "$MAN_FILE" "$HOME/$MAN_FILES_PREFIX"


#22
mkdir "$MAN_DIR"

#23
mv "$HOME/$MAN_FILES_PREFIX"* "$MAN_DIR/"

#24
cat "$MAN_DIR/$MAN_FILES_PREFIX"* > "$MAN_NEW_FILE"
rm "$MAN_DIR/$MAN_FILES_PREFIX"*

#25
printCmp "$MAN_FILE" "$MAN_NEW_FILE"

#26
# Insert some content into the middle and the end of the file 
LINES=$(cat "$MAN_FILE" | wc -l)
sed -i "$(( $LINES / 2 ))i\\some_content_1" "$MAN_FILE"
echo "some_content_2" >> "$MAN_FILE"

#27,28
diff -u "$MAN_NEW_FILE" "$MAN_FILE" > "$MAN_PATCH_FILE"

#29
patch "$MAN_NEW_FILE" "$MAN_PATCH_FILE"

#30
printCmp "$MAN_FILE" "$MAN_NEW_FILE"

