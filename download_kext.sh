#!/bin/bash
download_kext_gh () {
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$FULL_KEXT_NAME/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_NAME-$TAG-RELEASE.zip
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
}

virtualsmc_download() {
    FULL_KEXT_NAME="acidanthera/VirtualSMC"
    KEXT_NAME="VirtualSMC"
    download_kext_gh
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
}

whatevergreen_download() {
    FULL_KEXT_NAME="acidanthera/WhateverGreen"
    KEXT_NAME="WhateverGreen"
    download_kext_gh
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
}

lilu_download() {
    FULL_KEXT_NAME="acidanthera/lilu"
    KEXT_NAME="Lilu"
    download_kext_gh
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
}

realtek8111_download() {
    FULL_KEXT_NAME="Mieze/RTL8111_driver_for_OS_X"
    KEXT_NAME="RealtekRTL8111"
    download_kext_gh
    unzip -qq "$KEXT_NAME-V$TAG.zip" || exit 1
}

applealc_download() {
    FULL_KEXT_NAME="acidanthera/AppleALC"
    KEXT_NAME="AppleALC"
    download_kext_gh
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
}

usbinjectall_download() {
    echo Downloading RehabMan-USBInjectAll-2018-1108.zip
    curl -# -L -O "https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2018-1108.zip" || exit 1
    unzip -qq "RehabMan-USBInjectAll-2018-1108.zip" || exit 1
}

main(){
    mkdir DownloadedKexts
    cd DownloadedKexts
    virtualsmc_download
    whatevergreen_download
    lilu_download
    realtek8111_download
    applealc_download
    usbinjectall_download
    ls
}

main