# assume we are running in a Vagrant-VM

if [ -d /vagrant ] ; then
    # role-paths are expected to be collected into /role/1, /roles/2, ...
    role_dirs=$(find /roles -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
    _old_ifs="$IFS" # save original IFS
    IFS="$(echo -en "\n\b")" # set IFS to linebreak
    for role in ${role_dirs[@]} ; do
	ROLESPEC_ANSIBLE_ROLES="${ROLESPEC_ANSIBLE_ROLES}:${role}"
    done
    IFS="$_old_ifs" # restore old IFS

    # If DebOps playbooks are available at /debops-playbooks, tell
    # `ansible_plugins` to use them
    if [ -d /debops-playbooks ] ; then
	DEBOPS_PLAYBOOKS=/debops-playbooks
    fi
fi
