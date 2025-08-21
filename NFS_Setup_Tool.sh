#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

show_progress() {
    
    echo -n "$1"
    for i in {1..20}; do
        echo -n "#"
        sleep 0.1
    done
    echo " Done!"
}

ping_check() {
    
    echo "Checking connectivity to $1 ..."
    if ping -c 3 $1 &> /dev/null; then
        echo "Ping successful!"
        return 0
    else
        echo "Ping failed! Make sure both machines are on the same network and can reach each other."
        return 1
    fi
}

install_nfs_server() {
    read -p "Enter client IP allowed to access the share: " CLIENT_IP
    ping_check $CLIENT_IP || return
    show_progress "Installing NFS server... "
    apt update -y
    apt install -y nfs-kernel-server
    mkdir -p /srv/nfs_share
    chown nobody:nogroup /srv/nfs_share
    chmod 777 /srv/nfs_share
    grep -q "^/srv/nfs_share" /etc/exports || echo "/srv/nfs_share $CLIENT_IP(rw,sync,no_subtree_check)" >> /etc/exports
    exportfs -a
    systemctl enable nfs-server
    systemctl restart nfs-server
    echo "NFS server setup complete. Shared directory: /srv/nfs_share"
}

install_nfs_client() {
    read -p "Enter server IP to mount from: " SERVER_IP
    ping_check $SERVER_IP || return
    show_progress "Installing NFS client... "
    apt update -y
    apt install -y nfs-common
    mkdir -p /mnt/nfs_client
    mount -t nfs $SERVER_IP:/srv/nfs_share /mnt/nfs_client
    if mount | grep -q "/mnt/nfs_client"; then
        echo "NFS share mounted successfully at /mnt/nfs_client"
    else
        echo "Failed to mount NFS share. Check network and server IP."
    fi
}

show_menu() {
    echo "==============================================="
    echo "        NFS Setup Tool - By BnHany            "
    echo "==============================================="
    echo " [1] Setup as NFS Server"
    echo " [2] Setup as NFS Client"
    echo " [3] Help / How to use"
    echo " [0] Exit"
    echo "==============================================="
    read -p "Enter your choice: " choice

    case "$choice" in
        1) install_nfs_server ;;
        2) install_nfs_client ;;
        3) 
            echo "Choose 1 to setup this machine as NFS Server."
            echo "Choose 2 to setup this machine as NFS Client."
            echo "Make sure server and client can ping each other."
            ;;
        0) exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
}

while true; do
    show_menu
done
