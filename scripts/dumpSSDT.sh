#!/bin/bash
#==============================================================
# Filename: dumpSSDT.sh
# Version 23.8.23
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==============================================================

checkPlatform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then {
        echo "macOS host detected, aborting..."
        exit 1
    } else {
        echo "Not macOS"
    }
}
checkPlatform