#!/bin/bash

#####################################################################
# Script Name: list_users.sh (Improved)
# Description: Display a clean and detailed list of system users.
# Author: Farzan Afringan
# Updated: July 11, 2025
#####################################################################

# Print table header
printf "%-20s %-10s %-8s %-25s %-20s %-10s\n" "Username" "UID" "Type" "Last Login" "Shell" "Status"
echo "-------------------------------------------------------------------------------------------------------------"

# Read users from /etc/passwd
while IFS=: read -r username x uid gid full home shell; do
    # Skip system users without a valid shell
    [[ "$shell" == "/usr/sbin/nologin" || "$shell" == "/bin/false" || "$shell" == "/sbin/nologin" ]] && continue

    # Determine user type based on UID
    if [ "$uid" -lt 1000 ]; then
        type="System"
    else
        type="Normal"
    fi

    # Check if 'lastlog' exists
    if command -v lastlog >/dev/null 2>&1; then
        last_login=$(lastlog -u "$username" | awk 'NR==2 {print $4, $5, $6}')
        [[ "$last_login" == "**Never" || -z "$last_login" ]] && last_login="Never"
    else
        last_login="N/A"
    fi

    # Check account status
    if command -v passwd >/dev/null 2>&1 && passwd -S "$username" &>/dev/null; then
        status_code=$(passwd -S "$username" 2>/dev/null | awk '{print $2}')
        [[ "$status_code" == "L" ]] && status="Locked" || status="Active"
    else
        status="Unknown"
    fi

    # Print user info
    printf "%-20s %-10s %-8s %-25s %-20s %-10s\n" "$username" "$uid" "$type" "$last_login" "$shell" "$status"

done < /etc/passwd
