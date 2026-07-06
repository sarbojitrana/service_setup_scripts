#!/bin/bash

set -euo pipefail

USR='devops'
SCRIPT='multios_websetup.sh'
for host in $(cat remhosts)
do
	echo "###########################################"
	echo "Connecting to $host"
	echo "Pushing Script to $host"
	scp $SCRIPT  $USR@$host:/tmp/
	echo "Executing Script on $host"
	ssh $USR@$host sudo /tmp/$SCRIPT
	ssh $USR@$host sudo rm -rf /tmp/$SCRIPT
	echo "###########################################"
	echo
done
