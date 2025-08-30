#!/bin/sh
set -e

echo "[entrypoint] Starting CUPS + SANE container..."

# Ensure runtime dirs exist
mkdir -p /run/dbus /var/run/cups /var/log/cups /var/lib/saned

# Start dbus (needed by Avahi and some cups backends)
if [ -f /run/dbus/pid ] || [ -f /run/dbus/dbus.pid ]; then
    echo "[entrypoint] Removing stale dbus pid file..."
    rm -f /run/dbus/pid /run/dbus/dbus.pid
fi

echo "[entrypoint] Starting dbus..."
dbus-daemon --system --fork

# Start Avahi (mDNS printer discovery)
echo "[entrypoint] Starting avahi-daemon..."
avahi-daemon --no-chroot --daemonize

# Start CUPS
echo "[entrypoint] Starting cupsd..."
/usr/sbin/cupsd -f &
CUPSD_PID=$!

# Start saned (scanner daemon) if enabled
if [ "${ENABLE_SANED:-1}" = "1" ]; then
    echo "[entrypoint] Starting saned..."
    /usr/sbin/saned -d &
    SANED_PID=$!
fi

# Trap signals for clean shutdown
cleanup() {
    echo "[entrypoint] Stopping services..."
    [ -n "$SANED_PID" ] && kill "$SANED_PID" 2>/dev/null || true
    [ -n "$CUPSD_PID" ] && kill "$CUPSD_PID" 2>/dev/null || true
    pkill avahi-daemon || true
    pkill dbus-daemon || true
    rm -f /run/dbus/pid /run/dbus/dbus.pid
    exit 0
}

trap cleanup SIGINT SIGTERM

# Wait for cupsd (main service) to exit
wait $CUPSD_PID
