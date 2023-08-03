#!/bin/bash

function status_check {
    output=$(systemctl status $1 &> /dev/null)
    case "$?" in 
    "4")
        echo "process $1 does not exist. Please choose a correct process name."
    ;;
    "0")
        echo "Process $1 is running."
    ;;
    "3")
        restart_svc $1
    ;;
    esac
}

function restart_svc {
    for i in {1..3}
    do
        echo "Process $1 is not running. Attempting to restart....."
        start_status=$(systemctl start $1 &> /dev/null)
        if [[ $? -eq 0 ]]
        then
            echo "Process $1 is running."
            exit 0
        fi
    done
    echo "Maximum attempts reached to restart the Process $1. Please check the process manually."
}

if [[ $# -eq 0 ]]
then
    echo "Provide one argument, i.e service name."
    exit 0
fi
status_check $1


# Monitoring script works on based upon the exit status of systemctl utility.
# 0 - when a service is running properly.
# 3 - when a service is exists and not running.
# 4 - when a service is not installed/created in the system.