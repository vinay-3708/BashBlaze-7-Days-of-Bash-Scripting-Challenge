#!/bin/bash


function main_menu {
    #clear
    echo "--------------- Monitoring Metric Scripts ---------------"
    echo "1. View System Metrics."
    echo "2. Monitor a specific service."
    echo "3. Exit."
}

function system_metrics {
    #clear
    CPU_Usage=$(top -bn1 | awk -F' ' '/Cpu/ {print $2}' |  cut -d '.' -f1)
    Mem_Usage=$(free | grep -v total | grep Mem  | awk -F' ' '{print  ($3/$2)*100}' | cut -d '.' -f1)
    disk_usage=$(df --total | grep total | awk -F ' ' '{print $5}')
    echo "--------------- System Metrics ---------------"
    echo "CPU_Usage: $CPU_Usage %        Mem_Usage: $Mem_Usage %          Disk_Usage: $disk_usage"
    read -p "Press Enter to continue." SEL1
}

function service_status {
    #clear
    echo "--------------- Monitor a Specific service ---------------"
    read -p "Enter a service name: " SRV_NAME
    output=$(systemctl status $SRV_NAME &> /dev/null)
    case "$?" in 
    "4")
        echo "Service $SRV_NAME does not exist. Please choose a Service process name."
    ;;
    "0")
        echo "Service $SRV_NAME is running."
    ;;
    "3")
        echo "Service $SRV_NAME is not running."
    ;;
    esac
    read -p "Press Enter to Continue." SEL2
}

while [ true ]
do
    main_menu
    echo ""
    read -p "Enter the selection: " SEL
    case "$SEL" in 
    "1")
        system_metrics
    ;;
    "2")
        service_status
    ;;
    "3")
        exit 0
    ;;
    *)
        echo "Invalid Selection. Choose the correct one."
        sleep 5
    ;;
    esac
done
