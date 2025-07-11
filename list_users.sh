#!/bin/bash

#####################################################################
# Script Name: list_users.sh
# Description: Display a clean and detailed list of system users.
# Author: Farzan Afringan
# Created: July 11, 2025
#####################################################################

# Print table header
printf "%-20s %-10s %-8s %-25s %-20s %-10s\n" "Username" "UID" "Type" "Last Login" "Shell" "Status"
echo "-------------------------------------------------------------------------------------------------------------"

# Read users from /etc/passwd
while IFS=: read -r username x uid gid full home shell; do
    # Skip system users without a valid shell
    [[ "$shell" == "/usr/sbin/nologin" || "$shell" == "/bin/false" ]] && continue

    # Determine user type based on UID
    if [ "$uid" -lt 1000 ]; then
        type="System"
    else
        type="Normal"
    fi

    # Get last login info using lastlog
    last_login=$(lastlog -u "$username" | awk 'NR==2 {print $4, $5, $6}')
    [[ "$last_login" == "**Never" ]] && last_login="Never"

    # Get account status (Locked or Active)
    status=$(passwd -S "$username" 2>/dev/null | awk '{print $2}')
    [[ "$status" == "L" ]] && status="Locked" || status="Active"

    # Print user info
    printf "%-20s %-10s %-8s %-25s %-20s %-10s\n" "$username" "$uid" "$type" "$last_login" "$shell" "$status"

done < /etc/passwd
