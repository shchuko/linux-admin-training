#!/bin/bash

tar -czvf mydatetime-1.0.tar.gz mydatetime-1.0
cp mydatetime-1.0.tar.gz "$HOME"/rpmbuild/SOURCES
rpmbuild -bb mydatetime.spec
cp "$HOME"/rpmbuild/RPMS/x86_64/mydatetime-1.0-1.x86_64.rpm "$PWD"
dnf install mydatetime-1.0-1.x86_64.rpm -y

