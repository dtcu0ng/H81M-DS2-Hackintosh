#!/bin/bash
download_kext () {
    echo Downloading $kext_name
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$full_kext_name/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/$full_kext_name/releases/download/$TAG/$kext_name-$TAG-RELEASE.zip
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$kext_name-$TAG-RELEASE.zip" || exit 1
}

full_kext_name = "acidanthera/VirtualSMC"
kext_name = "VirtualSMC"
download_kext

full_kext_name = "acidanthera/WhateverGreen"
kext_name = "WhateverGreen"
download_kext