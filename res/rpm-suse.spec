Name:       shopremote
Version:    1.1.9
Release:    0
Summary:    RPM package
License:    GPL-3.0
Requires:   gtk3 libxcb1 libXfixes3 alsa-utils libXtst6 libva2 pam gstreamer-plugins-base gstreamer-plugin-pipewire
Recommends: libayatana-appindicator3-1 xdotool

# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/

%description
The best open-source remote desktop client software, written in Rust.

%prep
# we have no source, so nothing here

%build
# we have no source, so nothing here

%global __python %{__python3}

%install
mkdir -p %{buildroot}/usr/bin/
mkdir -p %{buildroot}/usr/share/shopremote/
mkdir -p %{buildroot}/usr/share/shopremote/files/
mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps/
mkdir -p %{buildroot}/usr/share/icons/hicolor/scalable/apps/
install -m 755 $HBB/target/release/shopremote %{buildroot}/usr/bin/shopremote
install $HBB/libsciter-gtk.so %{buildroot}/usr/share/shopremote/libsciter-gtk.so
install $HBB/res/shopremote.service %{buildroot}/usr/share/shopremote/files/
install $HBB/res/128x128@2x.png %{buildroot}/usr/share/icons/hicolor/256x256/apps/shopremote.png
install $HBB/res/scalable.svg %{buildroot}/usr/share/icons/hicolor/scalable/apps/shopremote.svg
install $HBB/res/shopremote.desktop %{buildroot}/usr/share/shopremote/files/
install $HBB/res/shopremote-link.desktop %{buildroot}/usr/share/shopremote/files/

%files
/usr/bin/shopremote
/usr/share/shopremote/libsciter-gtk.so
/usr/share/shopremote/files/shopremote.service
/usr/share/icons/hicolor/256x256/apps/shopremote.png
/usr/share/icons/hicolor/scalable/apps/shopremote.svg
/usr/share/shopremote/files/shopremote.desktop
/usr/share/shopremote/files/shopremote-link.desktop

%changelog
# let's skip this for now

%pre
# can do something for centos7
case "$1" in
  1)
    # for install
  ;;
  2)
    # for upgrade
    systemctl stop shopremote || true
  ;;
esac

%post
cp /usr/share/shopremote/files/shopremote.service /etc/systemd/system/shopremote.service
cp /usr/share/shopremote/files/shopremote.desktop /usr/share/applications/
cp /usr/share/shopremote/files/shopremote-link.desktop /usr/share/applications/
systemctl daemon-reload
systemctl enable shopremote
systemctl start shopremote
update-desktop-database

%preun
case "$1" in
  0)
    # for uninstall
    systemctl stop shopremote || true
    systemctl disable shopremote || true
    rm /etc/systemd/system/shopremote.service || true
  ;;
  1)
    # for upgrade
  ;;
esac

%postun
case "$1" in
  0)
    # for uninstall
    rm /usr/share/applications/shopremote.desktop || true
    rm /usr/share/applications/shopremote-link.desktop || true
    update-desktop-database
  ;;
  1)
    # for upgrade
  ;;
esac
