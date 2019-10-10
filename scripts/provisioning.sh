#!/usr/bin/env bash

################################################################################
################################################################################
#
# This script calls the needed DebOps plays/roles in order to provision a new cloud VM,
# then prepares the VM to be ansible managed and runs additional Ansible Playbooks in the correct order.
#
# Usage:
#     ./provisioning.sh -l <host-or-group-to-provision>
#
#     You can also pass ansible parameter to DebOps
#     ./provisioning.sh -l <host-or-group-to-provision> -t role::pki --skip-tags role::owncloud --user root -vvv
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

# Run the debops.pki role a second time to really get the Let's Encrypt TLS certificates.
# The second run is necessary for DebOps to request the Let's Encrypt certificates
# sucessfully,due to a "chicken-egg problem":
#  - the debops.pki role needs the nginx server configured with debops.nginx role
#    to handle the ACME http-01 authentication request
#  - So, on the first run, Let's Encrypt certificates cannot be acquired because
#    nginx server isn't ready to help authenticate the request.
#
# In order to get Let's Encrypt/ACME TLS certificates you need to meet this requirements:
#  - nginx server is configured: add your server to the [debops_service_nginx] group
#  - the host has at least 1 public IP address
#  - add DNS records pointing to the public IP address of the server for ALL domains,
#    for which an LE certificate is being requested, e.g 'cloud.example.net'
#  - a separate PKI realm is configured:
#      pki_host_realms:
#        # Nextcloud
#        - name: 'cloud.example.net'
#          acme: true
#          acme_domains:
#            - 'cloud.example.net'
#
debops service/pki $@
