#!/bin/sh

USB_DIR=$(find /mnt -maxdepth 1 -type d -name 'usb-*' | head -n 1)
if [ -z "$USB_DIR" ]; then
    echo "USB диск не найден!"
    exit 1
fi
export USB_PATH="$USB_DIR"
echo "USB путь: $USB_PATH"

mkdir -p "$USB_PATH/$1"
echo "Создана $USB_PATH/$1"