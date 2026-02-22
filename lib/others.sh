#!/usr/bin/bash


# Kill Background Process
kill_pid() {
	check_PID="php cloudflared"
	for process in ${check_PID}; do
		if [[ $(pidof ${process}) ]]; then # Check for Process
			killall ${process} > /dev/null 2>&1 # Kill the Process
		fi
	done
}

kill_pid

# capture program terminate
terminate() {
    echo -e "\n\n    ${cyan}[${red}!${cyan}]${red} Program terminated.${nocolor}"
    pkill -f "php" 2>/dev/null
    pkill -f "cloudflared" 2>/dev/null
    # Cleanup files
    move_capture_file 2>/dev/null
    rm -rf "$SCRIPT_DIR/.server/"* 2>/dev/null
    exit 0
}

# Exit Message
exit_msg(){
    echo -e "\n    ${red}[${orange}!${red}]${white} Exiting..."
    pkill -f "php" 2>/dev/null
    pkill -f "cloudflared" 2>/dev/null
    # Cleanup files
    move_capture_file 2>/dev/null
    rm -rf "$SCRIPT_DIR/.server/"* 2>/dev/null
    exit 1
}

# Invalid Options
invalid_options(){
    echo -e "\n    ${red}[${orange}✖${red}]${white}Invalid options! Exiting..."
    pkill -f "php" 2>/dev/null
    pkill -f "cloudflared" 2>/dev/null
    # Cleanup files
    move_capture_file 2>/dev/null
    rm -rf "$SCRIPT_DIR/.server/"* 2>/dev/null
    exit 1
}

# Back to Main Menu
back(){
    move_capture_file 2>/dev/null
    rm -rf "$SCRIPT_DIR/.server/"* 2>/dev/null
    main_menu
}