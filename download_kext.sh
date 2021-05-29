#!/bin/bash
download_kext () {
    echo Downloading $KEXT_NAME
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$FULL_KEXT_NAME/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_NAME-$TAG-RELEASE.zip
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
}

FULL_KEXT_NAME="acidanthera/VirtualSMC"
KEXT_NAME="VirtualSMC"
download_kext

FULL_KEXT_NAME="acidanthera/WhateverGreen"
KEXT_NAME="WhateverGreen"
download_kext