#!/bin/sh

# Create and set permissions for KEA runtime directory
mkdir -p /run/kea
chmod 750 /run/kea
chown kea:kea /run/kea

# Check if configuration file exists
if [ ! -f "/etc/kea/kea-dhcp4.conf" ]; then
    echo "ERROR: Configuration file /etc/kea/kea-dhcp4.conf not found"
    echo "Please mount your configuration directory to /etc/kea"
    exit 1
fi

# Validate configuration
echo "Validating KEA DHCP4 configuration..."
kea-dhcp4 -t /etc/kea/kea-dhcp4.conf

if [ $? -ne 0 ]; then
    echo "ERROR: Configuration validation failed"
    exit 1
fi

echo "Starting KEA DHCP4 server..."
exec kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
