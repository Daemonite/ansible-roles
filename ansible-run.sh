#!/bin/bash -e
# script for running ansible internally on the instance instead of from the local machine

PLAYBOOK=""
GROUP=""
EXTRA_VARS=""

# parse options
while : 
do
    if [[ "$1" == --* ]]; then
    	case $1 in
			"--playbook" ) PLAYBOOK=$2; shift; shift;;
            "--group" ) GROUP=$2; shift; shift;;
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

echo -e "[${GROUP}]\n127.0.0.1" > /etc/ansible/hosts

echo "BUILDING WITH VARS: ${EXTRA_VARS}"
ansible-playbook -v -c local "${PLAYBOOK}" --extra-vars "${EXTRA_VARS}"
