#!/bin/bash


# Variable Declaration
#PACKAGE="httpd wget unzip"
#SVC="httpd"
URL='https://www.tooplate.com/zip-templates/2165_neon_carbon.zip'
ART_NAME='2165_neon_carbon'
TEMPDIR="/tmp/webfiles"

dnf --help &> /dev/null

if [ $? -eq 0 ]
then
	PACKAGE="httpd wget unzip"
	SVC="httpd"
	echo "Running Setup on CentOS"
	# Installig Dependencies
	echo "#############################################"
	echo "Installing packages"
	echo "#############################################"
	sudo dnf install $PACKAGE -y &> /dev/null
	echo	

	# Start & Enable Service
	echo "#############################################"
	echo "Start & Enable HTTPD Service"
	echo "#############################################"
	sudo systemctl start "$SVC"
	sudo systemctl enable "$SVC"
	echo

	# Create Temp Directory


	echo "#############################################"
	echo "Starting Artifact Deployment"
	echo "#############################################"
	mkdir -p "$TEMPDIR"
	cd "$TEMPDIR"
	echo


	curl -fsSLOJ "$URL"
	unzip "$ART_NAME.zip" > /dev/null
	sudo cp -r "$ART_NAME"/* /var/www/html/
	echo


	# Bounce Service

	echo "#############################################"
	echo "Restarting HTTPD service"
	echo "#############################################"
	sudo systemctl restart "$SVC"
	echo

	# Clean up

	echo "#############################################"
	echo "Removing Temporary Files"
	echo "#############################################"
	rm -rf "$TEMPDIR"
	echo


	echo "#############################################"
	sudo systemctl is-active "$SVC"
	echo
	echo "#############################################"
	ls -l /var/www/html
else
	# Set Variables for Ubuntu
	PACKAGE="apache2 wget unzip"
	SVC="apache2"
	echo "Running Setup on Ubuntu"
	# Installig Dependencies
	echo "#############################################"
	echo "Installing packages"
	echo "#############################################"
	sudo apt update  &> /dev/null
	sudo apt install $PACKAGE -y &> /dev/null
	echo

	# Start & Enable Service
	echo "#############################################"
	echo "Start & Enable HTTPD Service"
	echo "#############################################"
	sudo systemctl start "$SVC"
	sudo systemctl enable "$SVC"
	echo

	# Create Temp Directory


	echo "#############################################"
	echo "Starting Artifact Deployment"
	echo "#############################################"
	mkdir -p "$TEMPDIR"
	cd "$TEMPDIR"
	echo


	curl -fsSLOJ "$URL"
	unzip "$ART_NAME.zip" > /dev/null
	sudo cp -r "$ART_NAME"/* /var/www/html/
	echo


	# Bounce Service

	echo "#############################################"
	echo "Restarting HTTPD service"
	echo "#############################################"
	sudo systemctl restart "$SVC"
	echo

	# Clean up

	echo "#############################################"
	echo "Removing Temporary Files"
	echo "#############################################"
	rm -rf "$TEMPDIR"
	echo


	echo "#############################################"
	sudo systemctl is-active "$SVC"
	echo
	echo "#############################################"
	ls -l /var/www/html
fi
