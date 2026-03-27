# Linux System Monitor

A simple bash script that shows system info — CPU, memory, disk, network, running services — right in your terminal. Built this while learning Linux on Fedora.

## What it does

- Shows CPU load and uptime
- Memory usage (total/used/free)
- Disk usage per partition
- Network status (hostname, IP, internet check)
- Service status (sshd, crond, firewalld)
- Alerts if disk > 80% or memory > 85%
- Logs everything to `~/monitor.log`

## Preview

```
=============================
   LINUX SYSTEM MONITOR
   2026-03-27 09:00:15
=============================

-- CPU & Load --
Uptime   : up 6 hours, 13 minutes
Load avg : 0.45 0.38 0.31

-- Memory --
Total: 7.5Gi | Used: 5.9Gi | Free: 1.2Gi

-- Disk --
/ -> 13% of 235G

-- Network --
Hostname : sanro-Fedora
IP Addr  : 10.130.96.234
Internet : Connected

-- Services --
  sshd: running
  crond: running
  firewalld: running

-- Alerts --
no critical alerts

=============================
   done
=============================
```

## How to use

```bash
git clone https://github.com/sanromarth/linux-system-monitor.git
cd linux-system-monitor
chmod +x monitor.sh
./monitor.sh
```

To install system-wide:

```bash
sudo cp monitor.sh /usr/local/bin/system-monitor
system-monitor
```

## Works on

- Fedora (tested)
- RHEL / CentOS
- Ubuntu / Debian
- Any distro with bash 4+ and standard tools (free, df, uptime, ping, systemctl)

## Project structure

```
linux-system-monitor/
├── monitor.sh    # the script
├── LICENSE        # MIT
└── README.md
```

## License

MIT
