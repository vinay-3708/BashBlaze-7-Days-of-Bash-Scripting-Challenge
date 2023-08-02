#!/bin/bash

function usage {
        echo "Usage: ./user_management_vny.sh [OPTIONS]"
        echo "Options:"
        echo -e "\t -c, \t --create \t Create a new user account."
        echo -e "\t -d, \t --delete \t Delete an existing user account."
        echo -e "\t -r, \t --reset \t Reset password for an existing user account."
        echo -e "\t -l, \t --list \t List all user accounts on the system."
        echo -e "\t -h, \t --help \t Display this help and exit."
}

if [[ $# == 1 ]]
then
        case "$1" in
        "-c" | "--create")
                read -p "Enter the new username: " USR_NAME
                EXIST_STATUS=$(cat /etc/passwd | awk -F':' '{print $1}' | grep $USR_NAME)
                if [[ -z $EXIST_STATUS ]]
                then
                        read -s -p "Enter the password for $USR_NAME username: " PSS
                        useradd -p $PSS $USR_NAME
                        echo "User account '$USR_NAME' is created successfully."
                else
                        echo -e "Error: The username '$USR_NAME' already exists. Please choose a different name."
                fi
        ;;
        "-d" | "--delete")
                read -p "Enter the username to delete: " USR_NAME
                EXIST_STATUS=$(cat /etc/passwd | awk -F':' '{print $1}' | grep $USR_NAME)
                if [[ -z $EXIT_STATUS ]]
                then
                        echo "Error: The username '$USR_NAME' does not exist. Please enter a valid username."
                else
                        userdel $USR_NAME
                        echo "User account '$USR_NAME' is deleted successfully."
                fi
        ;;
        "-r" | "--reset")
                read -p "Enter the username to reset password: " USR_NAME
                EXIST_STATUS=$(cat /etc/passwd | awk -F':' '{print $1}' | grep $USR_NAME)
                if [[ -z $EXIST_STATUS ]]
                then
                        echo -e "Error: The username '$USR_NAME' does not exists. Please choose a different name."
                else
                        read -s -p "Enter the new password for username '$USR_NAME' : " PSS
                        echo "$USR_NAME:$PSS" | sudo chpasswd
                        echo "Password for username '$USR_NAME' has changed successfully."
                fi
        ;;
        "-l" | "--list")
                echo "User accounts on the system:"
                awk -F':' '{print " - " $1 "(UID="$3", GID="$4")"}' /etc/passwd
        ;;
        "-h" | "--help")
                usage
        ;;

        *)
                echo "Error: Number of arguments provided wrong"
                usage
        ;;
        esac
else
        echo "Error: Number of arguments provided wrong"
        usage
fi
