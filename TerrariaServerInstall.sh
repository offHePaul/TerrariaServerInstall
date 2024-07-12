#!/bin/bash

# Global Variables
INSTALL_DIR="/opt/terraria"
SERVICE_NAME="terraria"
SERVER_EXECUTABLE="TerrariaServer"
DEFAULT_PORT=7777
CONFIG_FILE="serverconfig.txt"

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        printf "This script must be run as root. Exiting.\n" >&2
        exit 1
    fi
}

# Function to update and install required packages
install_dependencies() {
    apt update
    apt install -y wget unzip screen
}

# Function to download and extract the Terraria server
download_server() {
    mkdir -p "$INSTALL_DIR"
    local temp_file; temp_file=$(mktemp)
    wget -O "$temp_file" "https://terraria.org/server/terraria-server-linux.zip"
    unzip -o "$temp_file" -d "$INSTALL_DIR"
    rm "$temp_file"
}

# Function to create systemd service file
create_service() {
    local service_file="/etc/systemd/system/$SERVICE_NAME.service"
    printf "[Unit]\n" > "$service_file"
    printf "Description=Terraria Server\n" >> "$service_file"
    printf "After=network.target\n\n" >> "$service_file"
    printf "[Service]\n" >> "$service_file"
    printf "Type=simple\n" >> "$service_file"
    printf "ExecStart=%s/%s -config %s/%s\n" "$INSTALL_DIR" "$SERVER_EXECUTABLE" "$INSTALL_DIR" "$CONFIG_FILE" >> "$service_file"
    printf "WorkingDirectory=%s\n" "$INSTALL_DIR" >> "$service_file"
    printf "User=root\n" >> "$service_file"
    printf "Restart=on-failure\n\n" >> "$service_file"
    printf "[Install]\n" >> "$service_file"
    printf "WantedBy=multi-user.target\n" >> "$service_file"
}

# Function to create default config file
create_default_config() {
    printf "port=%d\n" "$DEFAULT_PORT" > "$INSTALL_DIR/$CONFIG_FILE"
    printf "maxplayers=8\n" >> "$INSTALL_DIR/$CONFIG_FILE"
    printf "worldpath=%s/Worlds\n" "$INSTALL_DIR" >> "$INSTALL_DIR/$CONFIG_FILE"
    printf "world=world.wld\n" >> "$INSTALL_DIR/$CONFIG_FILE"
    printf "autocreate=2\n" >> "$INSTALL_DIR/$CONFIG_FILE"
}

# Function to display the configuration menu
configuration_menu() {
    local choice
    local port maxplayers worldname difficulty
    while true; do
        printf "\nTerraria Server Configuration\n"
        printf "1. Set Server Port (Current: %d)\n" "$DEFAULT_PORT"
        printf "2. Set Maximum Players (Current: 8)\n"
        printf "3. Set World Name (Current: world.wld)\n"
        printf "4. Set World Difficulty (0: Normal, 1: Expert, 2: Master)\n"
        printf "5. Exit and Save Configuration\n"
        printf "Enter choice [1-5]: "
        read -r choice
        case $choice in
            1)
                printf "Enter new port: "
                read -r port
                if [[ $port =~ ^[0-9]+$ ]] && [[ $port -gt 0 ]] && [[ $port -le 65535 ]]; then
                    DEFAULT_PORT=$port
                else
                    printf "Invalid port number. Please enter a value between 1 and 65535.\n" >&2
                fi
                ;;
            2)
                printf "Enter maximum players: "
                read -r maxplayers
                if [[ $maxplayers =~ ^[0-9]+$ ]] && [[ $maxplayers -gt 0 ]]; then
                    sed -i "s/^maxplayers=.*$/maxplayers=$maxplayers/" "$INSTALL_DIR/$CONFIG_FILE"
                else
                    printf "Invalid number of players. Please enter a positive integer.\n" >&2
                fi
                ;;
            3)
                printf "Enter world name: "
                read -r worldname
                if [[ -n $worldname ]]; then
                    sed -i "s/^world=.*$/world=$worldname/" "$INSTALL_DIR/$CONFIG_FILE"
                else
                    printf "World name cannot be empty.\n" >&2
                fi
                ;;
            4)
                printf "Enter world difficulty (0: Normal, 1: Expert, 2: Master): "
                read -r difficulty
                if [[ $difficulty =~ ^[0-2]$ ]]; then
                    sed -i "s/^autocreate=.*$/autocreate=$difficulty/" "$INSTALL_DIR/$CONFIG_FILE"
                else
                    printf "Invalid difficulty level. Please enter 0, 1, or 2.\n" >&2
                fi
                ;;
            5)
                break
                ;;
            *)
                printf "Invalid choice. Please enter a number between 1 and 5.\n" >&2
                ;;
        esac
    done
}

# Function to start and enable the Terraria server service
start_service() {
    systemctl daemon-reload
    systemctl enable "$SERVICE_NAME"
    systemctl start "$SERVICE_NAME"
}

# Main function
main() {
    check_root
    install_dependencies
    download_server
    create_default_config
    configuration_menu
    create_service
    start_service
    printf "Terraria server installation and configuration completed.\n"
    printf "Use 'systemctl status terraria' to check the server status.\n"
}

# Execute main function
main
