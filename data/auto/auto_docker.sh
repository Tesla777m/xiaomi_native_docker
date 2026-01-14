#!/bin/sh

install() {
    # Register this script for autostart using UCI
    uci set firewall.fix_docker=include
    uci set firewall.fix_docker.type='script'
    uci set firewall.fix_docker.path="/data/auto/auto_docker.sh"
    uci set firewall.fix_docker.enabled='1'
    uci commit firewall
    echo "[OK] Docker autostart script installed."
}

uninstall() {
    # Remove this script from autostart
    uci delete firewall.fix_docker 2>/dev/null
    uci commit firewall
    echo "[INFO] Docker autostart script removed."
}

startup_script() {
    # Disable USB path validation in Xiaomi's init script
    sed -i '/valid_mountpath() {/a return 0' /etc/init.d/mi_docker

    # Start Docker from Xiaomi's init script
    /etc/init.d/mi_docker start
}

main() {
    [ -z "$1" ] && startup_script && return

    case "$1" in
        install)
            install
            ;;
        uninstall)
            uninstall
            ;;
        *)
            echo "[ERROR] Unknown parameter: $1"
            return 1
            ;;
    esac
}

main "$@"
