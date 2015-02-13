#!/bin/bash -e
# script for running ansible internally on the instance instead of from the local machine

PLAYBOOK=""
GROUP=""
EXTRA_VARS=""
INVENTORY="/etc/ansible/hosts"
APPLICATION_ENVIRONMENT=""

# parse options
while : 
do
    if [[ "$1" == --* ]]; then
    	case $1 in
			"--playbook" ) PLAYBOOK=$2; shift; shift;;
			"-i" ) INVENTORY=$2; shift; shift;;
            "--group" ) GROUP=$2; shift; shift;;
            "--environment" ) APPLICATION_ENVIRONMENT=$2; shift; shift;;
            "--inventory" ) INVENTORY=$2; shift; shift;;
			"--extra-vars" ) EXTRA_VARS=$2; shift; shift;;
    	    * ) echo "Error: unknown option $1"; echo;;
    	esac
    else
	   break
    fi
done

date

if [[ -z $(grep "8.8.8.8" /etc/network/interfaces) ]]; then
	sed -i 's/.*iface eth0 inet dhcp.*/&\n  dns-nameservers 8.8.8.8 8.8.4.4/' /etc/network/interfaces
	ifdown eth0 && ifup eth0
fi

apt-get install -y dpkg
dpkg -s ansible && ANSIBLE_INSTALLED='YES' || ANSIBLE_INSTALLED=''

if [[ -z $ANSIBLE_INSTALLED ]]; then
	apt-get update
	apt-get install -y -q python-software-properties 
	add-apt-repository ppa:rquillo/ansible
	apt-get update
	apt-get install -y -q ansible
	echo "127.0.0.1" > /etc/ansible/hosts
fi

if [[ -n "${GROUP}" ]]; then
	echo -e "[${APPLICATION_ENVIRONMENT}]\n127.0.0.1\n\n[${GROUP}]\n${APPLICATION_ENVIRONMENT}" > ${INVENTORY}
fi

echo "BUILDING WITH VARS: ${EXTRA_VARS}"
ANSIBLE_FORCE_COLOR=True ansible-playbook -v -c local "${PLAYBOOK}" -i "${INVENTORY}" --extra-vars "${EXTRA_VARS}"