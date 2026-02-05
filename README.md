# Fun with flakes ❄️
```
#######################################################

  _____        __ _       _ _           _       _     
 |_   _|      / _(_)     (_) |         | |     | |    
   | |  _ __ | |_ _ _ __  _| |_ _   _  | | __ _| |__  
   | | | '_ \|  _| | '_ \| | __| | | | | |/ _` | '_ \ 
  _| |_| | | | | | | | | | | |_| |_| | | | (_| | |_) |
 |_____|_| |_|_| |_|_| |_|_|\__|\__, | |_|\__,_|_.__/ 
                                 __/ |                
                                |___/                 

#######################################################
```

Repo base around playing with nixos, nix and flakes. Trying to build my lab partially in nixos and maybe with more.

## System Update

The `nix-update` command provides a one-stop solution for keeping your system up to date. It automatically detects the current host (atlas, orion, serveros) and performs all update tasks.

```bash
nix-update
```

This command will:
1. Update all flake inputs
2. Rebuild NixOS for the current host
3. Clean nix garbage (remove old generations)
4. Optimize the nix store
5. Check and apply firmware updates

## Security

### Firmware Updates

Check current firmware versions:
```bash
fwupdmgr get-devices
```

Check for available updates:
```bash
fwupdmgr refresh
fwupdmgr get-updates
```

Apply firmware updates:
```bash
fwupdmgr update
```

### Malware Scanning (ClamAV)

Update virus signatures:
```bash
sudo freshclam
```

Scan a specific directory:
```bash
clamscan -r /path/to/scan
```

Scan home directory and show only infected files:
```bash
clamscan -r --infected /home
```

Scan with detailed output and log:
```bash
clamscan -r --infected --log=/tmp/scan.log /home
```

Check daily scan status (atlas/serveros):
```bash
systemctl status clamav-scan.timer
journalctl -u clamav-scan.service
```

### Fail2Ban

Check banned IPs:
```bash
sudo fail2ban-client status sshd
```

Unban an IP:
```bash
sudo fail2ban-client set sshd unbanip <IP>
```

View fail2ban logs:
```bash
sudo journalctl -u fail2ban
```

### Suricata (atlas only)

Check service status:
```bash
sudo systemctl status suricata
```

View alerts:
```bash
sudo tail -f /var/log/suricata/fast.log
```

View full event log:
```bash
sudo tail -f /var/log/suricata/eve.json | jq
```

### Useful Security Commands

Check listening ports:
```bash
ss -tulpn
```

View failed SSH attempts:
```bash
journalctl -u sshd | grep -i "failed\|invalid"
```

Check firewall status:
```bash
sudo iptables -L -n
```

List active systemd timers:
```bash
systemctl list-timers
```
