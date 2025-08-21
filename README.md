# NFS Setup Tool v1.0

> A Bash-based interactive tool to set up and configure Network File System (NFS) server and client on Linux systems, with automated installation, network verification, and bidirectional file-sharing testing.

---

## Features

- Install and configure **NFS Server** and **NFS Client** on Debian-based systems (Kali, Ubuntu, etc.).
- Automatically sets up shared directories:
  - **Server:** `/srv/nfs_share`
  - **Client:** `/mnt/nfs_client`
- Verifies network connectivity using **ping** between server and client.
- Tests **bidirectional file access**:
  - Create file on client → verify on server.
  - Create file on server → verify on client.
- Interactive terminal menu with step-by-step guidance.

---

## Prerequisites

- Linux-based system (Debian, Ubuntu, Kali, etc.)
- **Root access** (required to install packages and configure NFS)
- Network: server and client on the same subnet
- Required packages:
  - `nfs-kernel-server` (server)
  - `nfs-common` (client)
  - `iputils-ping` (for `ping`, typically preinstalled)

---

## Installation & Setup

### 1) Update packages & install dependencies

```bash
sudo apt update
sudo apt install -y nfs-kernel-server nfs-common
```

### 2) Clone the repository & make the script executable

```bash
git clone https://github.com/BnHany/NFS-Setup-Tool.git
cd NFS-Setup-Tool
chmod +x NFS_Setup_Tool.sh
```

### 3) Run the tool (requires root)

```bash
sudo ./NFS_Setup_Tool.sh
```

---

## Interactive Menu

```
[1] Setup as NFS Server
[2] Setup as NFS Client
[3] Help / Instructions
[0] Exit
```

---

## Usage Instructions

### Server Setup

- Creates `/srv/nfs_share`.
- Updates `/etc/exports` automatically.
- Enables & starts NFS services.

### Client Setup

- Creates `/mnt/nfs_client`.
- Mounts server share using provided IP.
- Checks connectivity with `ping`.

---

## Bidirectional File Test

**From client:**

```bash
touch /mnt/nfs_client/client_test.txt
```

**Verify on server:**

```bash
ls -l /srv/nfs_share/
```

**From server:**

```bash
touch /srv/nfs_share/server_test.txt
```

**Verify on client:**

```bash
ls -l /mnt/nfs_client/
```

---

## Verification & Testing

**Check NFS exports on server:**

```bash
sudo exportfs -v
```

**Check mounted NFS shares on client:**

```bash
mount | grep nfs
```

**Check network connectivity:**

```bash
ping <server_ip>   # From client
ping <client_ip>   # From server
```

---

## File Structure

| File/Folder            | Description                                         |
|------------------------|-----------------------------------------------------|
| `interactive_nfs.sh`   | Main Bash script for setting up NFS server/client  |

---

## Notes & Tips

- Default export example used by the tool (if prompted):
  ```
  /srv/nfs_share  <client_subnet>(rw,sync,no_subtree_check)
  ```
- On Ubuntu/Kali, the service is typically `nfs-kernel-server`.  
  You can manage it with:
  ```bash
  sudo systemctl enable --now nfs-kernel-server
  sudo systemctl status nfs-kernel-server
  ```
- To persist the mount on the **client**, add to `/etc/fstab`:
  ```
  <server_ip>:/srv/nfs_share   /mnt/nfs_client   nfs   defaults   0  0
  ```
- If using a firewall, allow NFS-related services (e.g., via `ufw`):
  ```bash
  sudo ufw allow from <client_subnet>/24 to any port nfs
  sudo ufw reload
  ```


---
[**📖 Read Full Guide on Medium →**](https://bnhany.medium.com/nfs-setup-tool-v1-0-ada93d5d09d7)  
---

## Author

**BnHany**

© 2025 — Built with ❤️ to make Linux NFS setup simple and interactive.

---

## License

**MIT License**

Free to use, modify, and distribute. Please give credit and use responsibly.
