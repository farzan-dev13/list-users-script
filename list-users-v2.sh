#!/bin/sh

# Print table header
printf "%-20s %-6s %-8s %-25s %-20s %-10s %-30s\n" "Username" "UID" "Type" "Last Login" "Shell" "Status" "Full Name"
echo "-----------------------------------------------------------------------------------------------------------------------------"

# Use getent for compatibility across Linux distributions
getent passwd | while IFS=: read -r username x uid gid gecos home shell; do

    # Skip system/service accounts without valid shells
    case "$shell" in
        *nologin|/bin/false) continue ;;
    esac

    # Determine user type
    if [ "$uid" -lt 1000 ]; then
        type="System"
    else
        type="Normal"
    fi

    # Get last login (fallbacks for systems without 'lastlog')
    if command -v lastlog >/dev/null 2>&1; then
        last_login=$(lastlog -u "$username" | awk 'NR==2 {print $4, $5, $6}')
        [ "$last_login" = "**Never" ] || [ -z "$last_login" ] && last_login="Never"
    elif [ -f "/var/log/lastlog" ]; then
        last_login="Exists(log)"
    else
        last_login="N/A"
    fi

    # Check account status (locked/active)
    if command -v passwd >/dev/null 2>&1; then
        if passwd -S "$username" >/dev/null 2>&1; then
            status_code=$(passwd -S "$username" | awk '{print $2}')
            [ "$status_code" = "L" ] && status="Locked" || status="Active"
        elif [ -f "/etc/shadow" ]; then
            shadow_line=$(grep "^$username:" /etc/shadow)
            case "$shadow_line" in
                *'!'*|*'*'*) status="Locked" ;;
                *) status="Active" ;;
            esac
        else
            status="Unknown"
        fi
    else
        status="Unknown"
    fi

    # Print user info
    printf "%-20s %-6s %-8s %-25s %-20s %-10s %-30s\n" "$username" "$uid" "$type" "$last_login" "$shell" "$status" "$gecos"

done
