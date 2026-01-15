#!/bin/sh

# Create /etc/profile.d/ directory if it doesn't exist
if [ ! -d "/etc/profile.d" ]; then
    mkdir -p "/etc/profile.d"
fi

# Find the USB directory name
USB_DIR=$(find /mnt -maxdepth 1 -type d -name 'usb-*' | head -n 1)

# Check if USB directory was found
if [ -z "$USB_DIR" ]; then
    echo "Error: No USB directory found in /mnt"
    exit 1
fi

# Extract just the directory name (not full path)
USB_DIR_NAME=$(basename "$USB_DIR")
DOCKER_PATH="/mnt/$USB_DIR_NAME/mi_docker/docker-binaries"

# Check if docker-binaries directory exists
if [ ! -d "$DOCKER_PATH" ]; then
    echo "Error: Directory $DOCKER_PATH does not exist"
    exit 1
fi

# Check if the path is already in PATH
if echo ":$PATH:" | grep -q ":$DOCKER_PATH:"; then
    echo "Path is already in PATH, no changes made."
    exit 0
fi

# Create the docker.sh file in /etc/profile.d/
cat << EOF > /etc/profile.d/docker.sh
export PATH="\$PATH:$DOCKER_PATH"
EOF

# Make the file executable
chmod +x /etc/profile.d/docker.sh

echo "New path added to system profile: $DOCKER_PATH"
echo "Please log out and log back in for changes to take effect, or run: source /etc/profile"