#!/bin/bash

printTask() {
	echo "-----------"
	echo "- Task $1 -"
	[[ $# -eq 2 ]] && echo "$2"
	echo "-----------"
}

printTask 0 "Lab4"
printTask 1 "Install Developments Tools"

dnf groupinstall "Development Tools" -y
#yum group install "Development Tools"

printTask 2 "Install bastet from sources"
BASTET_DIRNAME="bastet-0.43"

dnf install boost-devel -y
dnf install ncurses-devel -y

tar --extract --file files/bastet-0.43.tgz
cd "$BASTET_DIRNAME" 

make

echo "install: 
	install ./bastet /usr/bin" >> Makefile

make install

cd -
rm -rf "$BASTET_DIRNAME" 

printTask 3 "List installed pkgs"

dnf list installed > task3.log

printTask 4 "GCC dependicies, libgcc usages"

dnf list gcc > task4_1.log
dnf repoquery --installed --whatrequires libgcc > task4_2.log

printTask 5 "Localrepo" 
dnf install createrepo

REPODIR="$HOME/localrepo"
REPOCONF="/etc/yum.repos.d/localrepo.repo"
RPMPKG="checkinstall-1.6.2-3.el6.1.x86_64.rpm"
mkdir -p "$REPODIR"
cp "files/$RPMPKG" "$REPODIR/"
createrepo "$REPODIR"

echo "[localrepo]
name=localrepo
baseurl=file://$REPODIR
enabled=1
gpgcheck=0" > "$REPOCONF"

printTask 6 "List repos"

dnf repolist all > task6.log

printTask 7 "Allow only local repos"

for FILE in /etc/yum.repos.d/*.repo; do
	RENAME=False
	grep -qE "^baseurl=file://.*" "$FILE" || RENAME=True 
	if [[ "$RENAME" = True ]]; then
		FILE_RENAMED="$FILE.disabled"
		mv "$FILE" "$FILE_RENAMED"
		echo "$FILE moved to $FILE_RENAMED"	
	fi
done

dnf repolist all
dnf repository-packages localrepo info
dnf repository-packages localrepo install -y

for FILE in /etc/yum.repos.d/*.repo.disabled; do
	FILE_RENAMED=$(echo "$FILE" | sed 's/\.disabled$//')
	mv "$FILE" "$FILE_RENAMED"
	echo "$FILE moved to $FILE_RENAMED"	
done

printTask 8 "deb to rpm"

sudo dnf install perl
tar --extract --file "files/alien_8.95.tar.xz"
cd alien-8.95
perl Makefile.PL
make
make install
cd -

/usr/local/bin/alien --to-rpm "files/fortunes-ru_1.52-2_all.deb"
rpm -Uvh --force "fortunes-ru-1.52-3.noarch.rpm"

rm -rf alien-* fortunes-*

printTask 9 "nano -> newnano"
dnf install "files/rpmrebuild-2.11-12.el8.noarch.rpm" -y

dnf download nano

NANO_RPM="nano-2.9.8-1.el8.x86_64.rpm"
NEWNANO_RPM="$HOME/rpmbuild/RPMS/x86_64/newnano-2.9.8-1.el8.x86_64.rpm"

rpmrebuild -epn "$NANO_RPM"

# Perform changes
#Name:          newnano
#.....
#%attr(0755, root, root) "/usr/bin/newnano"
#....

dnf install "$NEWNANO_RPM" -y
