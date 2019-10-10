#!/usr/bin/env bash

################################################################################
################################################################################
#
# https://docs.debops.org/en/master/user-guide/install.html
#
# This scripts installs DebOps and its dependencies on a (fresh) system.
# It creates a dedicated DebOps user (e.g. ansible) who should then execute all DebOps-playbooks.
# This script only installs DebOps globally , it does not initiliaze any DebOps-project.
#
################################################################################

set -o nounset -o pipefail -o errexit

# The username used by debops
DEBOPS_ADMIN_USER="${DEBOPS_ADMIN_USER:-ansible}"

echo "Install dependencies"
apt-get -q update
DEBIAN_FRONTEND=noninteractive apt-get \
  --no-install-recommends -yq install \
  iproute2 \
  levee \
  openssh-client \
  python3-apt \
  python3-distro \
  python3-dnspython \
  python3-future \
  python3-ldap \
  python3-openssl \
  python3-pip \
  python3-wheel \
  python3-setuptools \
  procps \
  sudo \
  tree \
  git \
  gpgv2 \
  uuid-runtime \
  sshpass \
  encfs \
  dirmngr \
  rsync \
  pass

echo "Install ansible and debops"
pip3 install \
 debops[ansible]

echo "Cleaning up cache directories..."
apt clean

echo "Add '${DEBOPS_ADMIN_USER}' admin user"
groupadd --system admins
echo "%admins ALL = (ALL:ALL) NOPASSWD: SETENV: ALL" > /etc/sudoers.d/admins
chmod 0440 /etc/sudoers.d/admins
useradd --user-group --create-home --shell /bin/bash \
       --home-dir /home/${DEBOPS_ADMIN_USER} --groups admins \
       --comment '${DEBOPS_ADMIN_USER} Admin User' ${DEBOPS_ADMIN_USER}
