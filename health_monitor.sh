#!/bin/bash

# Configuration
LOG_FILE="logs/health.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Check that the log directory exists
if [[ ! -d "logs" ]]; then
    echo "ERROR: logs directory does not exist."
    exit 1
fi

# Check that the log file is writable
if [[ ! -f "$LOG_FILE" || ! -w "$LOG_FILE" ]]; then
    echo "ERROR: Cannot write to $LOG_FILE"
    exit 1
fi

# Determine health status
check_status() {
    local value=$1

    if (( value >= 90 )); then
        echo "CRITICAL"
    elif (( value >= 70 )); then
        echo "WARNING"
    else
        echo "HEALTHY"
    fi
}

# Header
echo "========================================"
echo "       SERVER HEALTH MONITOR"
echo "========================================"
echo "Hostname: $(hostname)"
echo "Date: $(date)"

# CPU monitoring
echo ""
echo "CPU INFORMATION"
echo "----------------------------------------"

CPU_USAGE=$(top -l 1 | awk -F'[:,% ]+' '/CPU usage/ {for (i=1; i<=NF; i++) if ($i == "idle") {print 100-$(i-1); exit}}')

if [[ ! "$CPU_USAGE" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    echo "ERROR: Could not read CPU usage."
    exit 1
fi

CPU_STATUS=$(check_status "${CPU_USAGE%.*}")
echo "CPU Usage: ${CPU_USAGE}%"

# Memory monitoring
echo ""
echo "MEMORY INFORMATION"
echo "----------------------------------------"

MEMORY_INFO=$(vm_stat)
PAGE_SIZE=$(pagesize)

ACTIVE_PAGES=$(echo "$MEMORY_INFO" | awk '/Pages active/ {gsub("\\.", "", $3); print $3}')
INACTIVE_PAGES=$(echo "$MEMORY_INFO" | awk '/Pages inactive/ {gsub("\\.", "", $3); print $3}')
WIRED_PAGES=$(echo "$MEMORY_INFO" | awk '/Pages wired down/ {gsub("\\.", "", $4); print $4}')

if [[ ! "$ACTIVE_PAGES" =~ ^[0-9]+$ ||
      ! "$INACTIVE_PAGES" =~ ^[0-9]+$ ||
      ! "$WIRED_PAGES" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Could not read memory statistics."
    exit 1
fi

USED_MEMORY=$(((ACTIVE_PAGES + INACTIVE_PAGES + WIRED_PAGES) * PAGE_SIZE))
TOTAL_MEMORY=$(sysctl -n hw.memsize)
MEMORY_PERCENT=$((USED_MEMORY * 100 / TOTAL_MEMORY))
MEMORY_STATUS=$(check_status "$MEMORY_PERCENT")

echo "Memory Usage: ${MEMORY_PERCENT}%"

# Disk monitoring
echo ""
echo "DISK INFORMATION"
echo "----------------------------------------"

DISK_USAGE=$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')

if [[ ! "$DISK_USAGE" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Could not read disk usage."
    exit 1
fi

DISK_STATUS=$(check_status "$DISK_USAGE")
echo "Disk Usage: ${DISK_USAGE}%"



# Optional test overrides for status/exit-code TESTING----
if [[ "${TEST_MODE:-0}" == "1" ]]; then
	 echo "[TEST MODE] Simulated values are used for health status calculations."
    CPU_USAGE=${TEST_CPU:-10}
    MEMORY_PERCENT=${TEST_MEMORY:-10}
    DISK_USAGE=${TEST_DISK:-10}

    CPU_STATUS=$(check_status "${CPU_USAGE%.*}")
    MEMORY_STATUS=$(check_status "$MEMORY_PERCENT")
    DISK_STATUS=$(check_status "${DISK_USAGE%\%}")
fi




# Top CPU-consuming processes
echo ""
echo "TOP CPU PROCESSES"
echo "----------------------------------------"
ps -Ao pid,comm,%cpu,%mem -r | head -n 6

# Overall health
if [[ "$CPU_STATUS" == "CRITICAL" ||
      "$MEMORY_STATUS" == "CRITICAL" ||
      "$DISK_STATUS" == "CRITICAL" ]]; then
    OVERALL_STATUS="CRITICAL"
elif [[ "$CPU_STATUS" == "WARNING" ||
        "$MEMORY_STATUS" == "WARNING" ||
        "$DISK_STATUS" == "WARNING" ]]; then
    OVERALL_STATUS="WARNING"
else
    OVERALL_STATUS="HEALTHY"
fi

echo ""
echo "SYSTEM HEALTH"
echo "----------------------------------------"
echo "CPU Status:       ${CPU_STATUS}"
echo "Memory Status:    ${MEMORY_STATUS}"
echo "Disk Status:      ${DISK_STATUS}"
echo ""
echo "Overall Status:   ${OVERALL_STATUS}"
echo "========================================"

# Save the report BEFORE exiting
{
    echo "[$TIMESTAMP]"
    echo "CPU: ${CPU_USAGE}% - ${CPU_STATUS}"
    echo "Memory: ${MEMORY_PERCENT}% - ${MEMORY_STATUS}"
    echo "Disk: ${DISK_USAGE}% - ${DISK_STATUS}"
    echo "Overall Status: ${OVERALL_STATUS}"
    echo "----------------------------------------"
} >> "$LOG_FILE"

# Return an exit code based on overall health
case "$OVERALL_STATUS" in
    HEALTHY)  exit 0 ;;
    WARNING)  exit 1 ;;
    CRITICAL) exit 2 ;;
esac




















                                               







































  






