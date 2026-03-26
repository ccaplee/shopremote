Name:       shopremote
Version:    1.4.6
Release:    0
Summary:    RPM package
License:    GPL-3.0
URL:        https://shopremote.com
Vendor:     shopremote <info@shopremote.com>
Requires:   gtk3 libxcb libXfixes alsa-lib libva pam gstreamer1-plugins-base
Recommends: libayatana-appindicator-gtk3 libxdo
Provides:   libdesktop_drop_plugin.so()(64bit), libdesktop_multi_window_plugin.so()(64bit), libfile_selector_linux_plugin.so()(64bit), libflutter_custom_cursor_plugin.so()(64bit), libflutter_linux_gtk.so()(64bit), libscreen_retriever_plugin.so()(64bit), libtray_manager_plugin.so()(64bit), liburl_launcher_linux_plugin.so()(64bit), libwindow_manager_plugin.so()(64bit), libwindow_size_plugin.so()(64bit), libtexture_rgba_renderer_plugin.so()(64bit)

# https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/

%description
The best open-source remote desktop client software, written in Rust.

%prep
# we have no source, so nothing here

%build
# we have no source, so nothing here

# %global __python %{__python3}

%install

mkdir -p "%{buildroot}/usr/share/shopremote" && cp -r ${HBB}/flutter/build/linux/x64/release/bundle/* -t "%{buildroot}/usr/share/shopremote"
mkdir -p "%{buildroot}/usr/bin"
install -Dm 644 $HBB/res/shopremote.service -t "%{buildroot}/usr/share/shopremote/files"
install -Dm 644 $HBB/res/shopremote.desktop -t "%{buildroot}/usr/share/shopremote/files"
install -Dm 644 $HBB/res/shopremote-link.desktop -t "%{buildroot}/usr/share/shopremote/files"
install -Dm 644 $HBB/res/128x128@2x.png "%{buildroot}/usr/share/icons/hicolor/256x256/apps/shopremote.png"
install -Dm 644 $HBB/res/scalable.svg "%{buildroot}/usr/share/icons/hicolor/scalable/apps/shopremote.svg"

%files
/usr/share/shopremote/*
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
ln -sf /usr/share/shopremote/shopremote /usr/bin/shopremote
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
    rm /usr/bin/shopremote || true
    rmdir /usr/lib/shopremote || true
    rmdir /usr/local/shopremote || true
    rmdir /usr/share/shopremote || true
    rm /usr/share/applications/shopremote.desktop || true
    rm /usr/share/applications/shopremote-link.desktop || true
    update-desktop-database
  ;;
  1)
    # for upgrade
    rmdir /usr/lib/shopremote || true
    rmdir /usr/local/shopremote || true
  ;;
esac
