#!/bin/bash

echo "########################################"
date
ls /var/run/httpd/httpd.pid &> /dev/null

if [ $? -eq 0 ]
then
        echo "Httpd process is running"
else
        echo "Httpd process is not running"
        echo "Starting httpd process"
        systemctl start httpd &> /dev/null
        if [ $? -eq 0 ]
        then
                echo "Httpd process started"
        else
                echo "Could not start the httpd process, contact the admin."
        fi
fi

echo "#########################################"
echo
