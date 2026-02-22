#!/bin/bash

# Pakage Status
print_status() {
    local label_with_colors="    ${cyan}[${orange}+${cyan}]${nocolor} $1"
    local status=$2
    local total_width=50

    # 1. Remove ANSI color codes to get the "real" visible length
    # This regex strips everything from \e[ to 'm'
    local clean_label=$(echo -e "$label_with_colors" | sed 's/\x1b\[[0-9;]*m//g')
    local label_len=${#clean_label}
    
    # 2. Calculate dots based on visible characters
    local dot_count=$((total_width - label_len))

    local dots=""
    if [ $dot_count -gt 0 ]; then
        dots=$(printf '%*s' "$dot_count" '' | tr ' ' '.')
    fi

    # 3. Print the original colored label + dots + status
    printf "%b%s %b\n" "$label_with_colors" "$dots" "$status"
}

check_requirements() {
    local requirements=("$@")
    local missing=0
    
    for pkg in "${requirements[@]}"; do
        # Check if command exists or if the binary exists in the current directory
        if command -v "$pkg" >/dev/null 2>&1 || [[ -f "./$pkg" ]]; then
            print_status "${white}$pkg" "${green}Installed${nocolor}"
            sleep 0.4
        else
            print_status "${white}$pkg" "${red}Missing${nocolor}"
            missing=$((missing + 1))
            
            # AUTOMATIC INSTALLATION START
            echo -e "    ${red}[${orange}!${red}]${white} $pkg is required. Starting automatic installation...${nocolor}"
            
            # Special Case: Cloudflared
            if [[ "$pkg" == "cloudflared" ]]; then
                arch=$(uname -m)
                case $arch in
                    *arm*|*Android*) url="cloudflared-linux-arm" ;;
                    *aarch64*) url="cloudflared-linux-arm64" ;;
                    *x86_64*) url="cloudflared-linux-amd64" ;;
                    *) url="cloudflared-linux-386" ;;
                esac
                
                wget --no-check-certificate "https://github.com/cloudflare/cloudflared/releases/latest/download/$url" -O cloudflared > /dev/null 2>&1
                chmod +x cloudflared
                
            # Standard Packages
            else
                if [ "$KERNEL" == "Linux" ]; then
                    sudo apt update && sudo apt install "$pkg" -y
                elif [ "$KERNEL" == "macOS" ]; then
                    brew install "$pkg"
                elif [ "$KERNEL" == "Cygwin" ]; then
                    apt-cyg install "$pkg"
                else
                    echo -e "${red}[!] Kernel Not Detected: $KERNEL. Cannot auto-install.${nocolor}"
                    exit 1
                fi
            fi
            
            # Verify installation success
            if [[ $? -eq 0 ]]; then
                echo -e "    ${green}[${white}+${green}]${white} $pkg installed successfully.${nocolor}"
            else
                echo -e "    ${red}Error: $pkg installation failed. Exiting.${nocolor}"
                exit 1
            fi
            sleep 0.4
        fi
    done

    return $missing
}