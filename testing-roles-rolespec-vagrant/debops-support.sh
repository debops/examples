ansible_plugins () {
    # Clone and set up DebOps playbooks repository with Ansible plugins
    #
    # If DEBOPS_PLAYBOOKS is set, DebOps playbooks are assumed to be
    # already downloaded/cloned there.
    local debops_playbooks
    if [ -z "${DEBOPS_PLAYBOOKS}" ] ; then
        debops_playbooks="${HOME}/debops-playbooks"
	sudo apt-get -yq install python-netaddr
	git clone https://github.com/debops/debops-playbooks ${debops_playbooks}
    else
	debops_playbooks="${DEBOPS_PLAYBOOKS}"
    fi
    cat <<EOF >> $ROLESPEC_ANSIBLE_CONFIG
action_plugins = ${debops_playbooks}/playbooks/action_plugins
callback_plugins = ${debops_playbooks}/playbooks/callback_plugins
connection_plugins = ${debops_playbooks}/playbooks/connection_plugins
lookup_plugins = ${debops_playbooks}/playbooks/lookup_plugins
vars_plugins = ${debops_playbooks}/playbooks/vars_plugins
filter_plugins = ${debops_playbooks}/playbooks/filter_plugins
EOF
}
