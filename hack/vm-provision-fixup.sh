#!/usr/bin/env bash

# patch incompatible with fail-over DNS setup
SCRIPT='/etc/NetworkManager/dispatcher.d/fix-slow-dns'
if [[ -f "${SCRIPT}" ]]; then
    echo "Removing ${SCRIPT}..."
    rm "${SCRIPT}"
    sed -i -e '/^options.*$/d' /etc/resolv.conf
fi
unset SCRIPT

# Add new configuration Environment variable
SCRIPT=/etc/profile.d/openshift.sh
if ! grep -q KUBECONFIG $SCRIPT; then
    echo "Adding KUBECONFIG to $SCRIPT"
    if grep -q OPENSHIFTCONFIG $SCRIPT; then
        echo 'export KUBECONFIG=$OPENSHIFTCONFIG' >>$SCRIPT
    else
        echo 'export KUBECONFIG=/openshift.local.config/master/admin.kubeconfig' >>$SCRIPT
    fi
fi
unset SCRIPT
