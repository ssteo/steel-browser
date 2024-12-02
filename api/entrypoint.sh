#!/bin/sh

echo "Starting nginx..."
nginx -c /app/nginx.conf
# Check if nginx started successfully
if ! ps aux | grep nginx | grep -v grep > /dev/null; then
    echo "Failed to start nginx"
    exit 1
fi

# Create dbus directory and start daemon
echo "Starting dbus..."
mkdir -p /var/run/dbus
dbus-daemon --system --fork

# Check if Xvfb is already running
if ! pgrep -x "Xvfb" > /dev/null
then
    echo "Starting Xvfb..."
    Xvfb :10 -screen 0 1920x1080x8 -ac &
else
    echo "Xvfb is already running."
fi

# Set the DISPLAY environment variable
export DISPLAY=:10

# Set the CDP_REDIRECT_PORT environment variable
export CDP_REDIRECT_PORT=9223
export HOST=0.0.0.0

# Run the npm start command
env npm run start
