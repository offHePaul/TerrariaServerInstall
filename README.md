# Terraria Server Installation Script

This script automates the installation and configuration of a Terraria server on a Linux machine. It allows the user to choose various settings for the server via a menu interface.

## Features

- Automatically installs necessary dependencies
- Downloads and extracts the Terraria server
- Creates a systemd service for easy management
- Provides a configuration menu to customize server settings

## Requirements

- A Linux-based operating system (Ubuntu/Debian recommended)
- Root privileges

## Installation

1. Download the installation script:

    ```sh
    wget https://your-repository-link/terraria_server_install.sh
    chmod +x terraria_server_install.sh
    ```

2. Run the script with root privileges:

    ```sh
    sudo ./terraria_server_install.sh
    ```

3. Follow the on-screen menu to configure your server.

## Configuration Options

The script provides a menu to configure the following options:

- **Server Port:** Set the port number for the server (default is 7777).
- **Maximum Players:** Set the maximum number of players (default is 8).
- **World Name:** Set the name of the world file (default is `world.wld`).
- **World Difficulty:** Set the difficulty level (0: Normal, 1: Expert, 2: Master).

## Usage

After installation, you can manage the Terraria server using systemd commands:

- **Start the server:**

    ```sh
    sudo systemctl start terraria
    ```

- **Stop the server:**

    ```sh
    sudo systemctl stop terraria
    ```

- **Check the status of the server:**

    ```sh
    sudo systemctl status terraria
    ```

- **Enable the server to start on boot:**

    ```sh
    sudo systemctl enable terraria
    ```

## Uninstallation

To remove the Terraria server and its related files, run the following commands:

```sh
sudo systemctl stop terraria
sudo systemctl disable terraria
sudo rm /etc/systemd/system/terraria.service
sudo rm -r /opt/terraria
sudo systemctl daemon-reload
```

## Contributing

Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions, please reach out via the GitHub repository or directly at [hepaul.dev@gmail.com](hepaul.dev@gmail.com).

---

Happy Coding! 🚀
