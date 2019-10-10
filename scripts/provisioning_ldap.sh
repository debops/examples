#!/usr/bin/env bash

################################################################################
################################################################################
#
# This script calls the needed DebOps plays/roles in order to provision a new cloud VM,
# then prepares the VM to be ansible managed and runs additional Ansible Playbooks in the correct order.
#
# Usage:
#     ./provisioning_ldap.sh -l <host-or-group-to-provision>
#
#     You can also pass ansible parameter to DebOps
#     ./provisioning_ldap.sh -l <host-or-group-to-provision> -t role::pki --skip-tags role::owncloud --user root -vvv
#
################################################################################

set -o nounset -o pipefail -o errexit

# Check if we are in the correct root folder of the repo, and change upwards if needed
# otherwise debops won't work
if [[ ! -f .debops.cfg && -f ../.debops.cfg ]]; then
    echo "Running $0 from root of repo."
    pushd .. > /dev/null
fi

# Run the bootstrap DebOps playbook to make the VM a DebOps/Ansible managed host.
debops --become $@ bootstrap-ldap || debops --become --user root $@ bootstrap-ldap

# Execute all DebOps plays (site.yml) to install everything.
debops $@

# Run the PKI role a second time (the first is executed from the site.yml DebOps playbook)
#   The second run is necessary for DebOps to download/request the Let's Encrypt ACME TLS certificates
#   Somehow during the first run, only the internal CA TLS Certificates are installed, but not the ACME certificates.
#   Running role::pki helps to get the ACME certs.
debops -t role::pki $@
