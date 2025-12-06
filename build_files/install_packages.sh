#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

dnf5 install -y \
    freeipa-client \
    htop \
    bat \
    fd-find \
    ripgrep \
    poppler \
    qrencode \
    uv \
    zoxide \
    powerline-fonts \
    iftop \
    podlet \
    sccache \
&& chown root:sssd /usr/libexec/sssd/selinux_child \
&& restorecon /usr/libexec/sssd/selinux_child \
&& setcap cap_setgid,cap_setuid=p /usr/libexec/sssd/selinux_child

# Use a COPR Example:
dnf5 -y copr enable derenderkeks/proxmox-backup-client
dnf5 -y copr enable atim/starship
dnf5 -y copr enable lihaohong/yazi
dnf5 -y copr enable alternateved/eza
dnf5 -y install proxmox-backup-client starship yazi eza
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable derenderkeks/proxmox-backup-client
dnf5 -y copr disable atim/starship
dnf5 -y copr disable lihaohong/yazi
dnf5 -y copr disable alternateved/eza

# VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf5 -y install code
