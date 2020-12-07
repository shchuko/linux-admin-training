Name:		mydatetime
Version:	1.0
Release:	1
Summary:	Date&time display utility

Group:		Unspecified
License:	MIT
URL:		https://github.com/shchuko/linux-admin-training/tree/master/lab4/extratask
Source0:	https://github.com/shchuko/linux-admin-training/raw/master/lab4/extratask/mydatetime-1.0.tar.gz

BuildRequires: gcc
BuildRequires: make

%description
Date&time display utility

%global debug_package %{nil}
%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
%make_install

%files
%license LICENCE
%{_bindir}/%{name}


%changelog
* Mon Dec 7 2020 Vladislav Yaroshchuk <yaroshchuk2000@gmail.com> - 1.0
- First mydatetime package

