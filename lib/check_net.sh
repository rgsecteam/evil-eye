#!/bin/bash

# check internet connection
check_internet() {
    # -c 1: send only 1 packet
    if timeout 2 ping -c 1 www.github.com > /dev/null 2>&1; then
        return 0 # Success
    else
        return 1 # Failure
    fi
}

if check_internet; then
    int_status="${green}online${nocolor}"
    sleep 0.4
else
    int_status="${red}offline${nocolor}"
    sleep 0.2
    echo -e "    ${red}[${orange}!${red}]${white} Connection Offline. Exiting..."
    exit 1
fi
