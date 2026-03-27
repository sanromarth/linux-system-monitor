#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOG_FILE="$HOME/monitor.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "started"

echo -e "${BLUE}============================="
echo "   LINUX SYSTEM MONITOR"
echo -e "   $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "=============================${NC}"

# cpu and uptime
echo ""
echo -e "${YELLOW}-- CPU & Load --${NC}"
echo "Uptime   : $(uptime -p)"
echo "Load avg : $(cat /proc/loadavg | awk '{print $1, $2, $3}')"

# memory
echo ""
echo -e "${YELLOW}-- Memory --${NC}"
free -h | grep Mem | awk '{print "Total:", $2, "| Used:", $3, "| Free:", $4}'

# disk
echo ""
echo -e "${YELLOW}-- Disk --${NC}"
df -h | grep -v tmpfs | grep -v udev | grep -v "Filesystem" | awk '{print $6, "->", $5, "of", $2}'

# network
echo ""
echo -e "${YELLOW}-- Network --${NC}"
echo "Hostname : $(hostname)"
echo "IP Addr  : $(hostname -I | awk '{print $1}')"

if ping -c 1 -W 2 google.com > /dev/null 2>&1; then
    echo -e "Internet : ${GREEN}Connected${NC}"
    log "network ok"
else
    echo -e "Internet : ${RED}NOT Connected${NC}"
    log "network down"
fi

# services
echo ""
echo -e "${YELLOW}-- Services --${NC}"

check_service() {
    if systemctl is-active --quiet "$1" 2>/dev/null; then
        echo -e "  $1: ${GREEN}running${NC}"
    else
        echo -e "  $1: ${RED}stopped${NC}"
    fi
}

check_service sshd
check_service crond
check_service firewalld

# alerts
echo ""
echo -e "${YELLOW}-- Alerts --${NC}"

# disk alert if any partition over 80%
df -h | grep -v tmpfs | grep -v udev | grep -v Filesystem | while read line; do
    usage=$(echo "$line" | awk '{gsub(/%/,"",$5); print $5}')
    mount=$(echo "$line" | awk '{print $6}')
    if [[ "$usage" =~ ^[0-9]+$ ]] && [ "$usage" -gt 80 ]; then
        echo -e "${RED}WARNING: $mount is ${usage}% full${NC}"
        log "disk alert: $mount at ${usage}%"
    fi
done

# memory alert if over 85%
mem_total=$(free | grep Mem | awk '{print $2}')
mem_used=$(free | grep Mem | awk '{print $3}')
mem_pct=$((mem_used * 100 / mem_total))
if [ "$mem_pct" -gt 85 ]; then
    echo -e "${RED}WARNING: memory at ${mem_pct}%${NC}"
    log "memory alert: ${mem_pct}%"
fi

echo -e "${GREEN}no critical alerts${NC}"

echo ""
echo -e "${BLUE}=============================
   done
=============================${NC}"

log "completed"
