#!/usr/bin/env bash

################################################################################
################################################################################
#
# If there is no gpg key for the user, create one non-interactively.
#
################################################################################

set -o nounset -o pipefail -o errexit


GPG_KEY_TYPE="${GPG_KEY_TYPE:-RSA}"
GPG_KEY_LENGTH="${GPG_KEY_LENGTH:-4096}"
GPG_USER_REALNAME="${GPG_USER_REALNAME:-${USER}}"
GPG_USER_EMAIL="${GPG_USER_EMAIL:-${USER}@$(hostname -f)}"
GPG_KEY_EXPIRE_DATE="${GPG_KEY_EXPIRE_DATE:-0}"

echo "#### Install encfs and gpgv2 ####"
echo "Install dependencies"
sudo apt-get -q update
DEBIAN_FRONTEND=noninteractive sudo apt-get \
  --no-install-recommends -yq install \
    encfs \
    gpgv2 \
    dirmngr

echo "#### Creating ${GPG_KEY_TYPE} GPG Keypair for '${GPG_USER_REALNAME} <${GPG_USER_EMAIL}>'####"
# https://alexcabal.com/creating-the-perfect-gpg-keypair
# https://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html
cat >/tmp/.gpg.data <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: ${GPG_KEY_TYPE}
     Key-Length: ${GPG_KEY_LENGTH}
     Subkey-Type: ${GPG_KEY_TYPE}
     Subkey-Length: ${GPG_KEY_LENGTH}
     Name-Real: ${GPG_USER_REALNAME}
     Name-Email:${GPG_USER_EMAIL}
     Expire-Date: ${GPG_KEY_EXPIRE_DATE}
     # Do a commit here, so that we can later print "done" :-)
     %commit
     %echo done
EOF
gpg --list-secret-keys | grep -q '[ultimate]' || gpg --batch --generate-key /tmp/.gpg.data

gpg --list-secret-keys
