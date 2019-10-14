#!/usr/bin/env bash

################################################################################
################################################################################
#
# Given keyID (e.g 42ABCED23 or alice@example.com) fetch the pubKey,
# store it in the keyring and mark it as ultimate trust.
#
# Use case: add gpg keys from people/systems you trust to encrypt passwords with
# theese keys. So if you have 3 collegues the password store or encfs container
# will be encrypted, however it can be opened by the owners of the given keyIDs.
#
# Usage:
#   ./gpg_add_key_to_keyring.sh 42ABCED23
#   ./gpg_add_key_to_keyring.sh alice@example.com
#   ./gpg_add_key_to_keyring.sh alice@example.com
#
################################################################################

echo "#### Add additional keys to debops-padlock ####"

# Add given gpg key to keyring in order to encrypt the password for the encfs container with additional gpg keys.
gpg --keyserver pool.sks-keyservers.net --recv-keys "$1"

#Trust the keys noninteractive in batch
echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key "$1" trust
