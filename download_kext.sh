#!/bin/bash
prepare() {
    mkdir DownloadedKexts
    cd DownloadedKexts
}
download_kext_gh() {
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$FULL_KEXT_NAME/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_NAME-$TAG-RELEASE.zip
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
    rm "$KEXT_NAME-$TAG-RELEASE.zip" # clean up
}

download_kext_gh_custom() {  # for custom kexts are not have filename formatted with $KEXT_NAME-$TAG-$TARGET.zip or outside GitHub
    echo Downloading $KEXT_NAME
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_FILENAME.zip" || exit 1
    rm "$KEXT_FILENAME.zip"
}

virtualsmc_download() {
    FULL_KEXT_NAME="acidanthera/VirtualSMC"
    KEXT_NAME="VirtualSMC"
    download_kext_gh
}

whatevergreen_download() {
    FULL_KEXT_NAME="acidanthera/WhateverGreen"
    KEXT_NAME="WhateverGreen"
    download_kext_gh
}

lilu_download() {
    FULL_KEXT_NAME="acidanthera/lilu"
    KEXT_NAME="Lilu"
    download_kext_gh
}

realtek8111_download() {
    FULL_KEXT_NAME="Mieze/RTL8111_driver_for_OS_X"
    KEXT_NAME="RealtekRTL8111"
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$FULL_KEXT_NAME/releases/latest)
    TAG="${RELEASE_URL##*/}"
    KEXT_FILENAME="RealtekRTL8111-$TAG"
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_FILENAME.zip
    echo Downloading $KEXT_NAME v$TAG
}

applealc_download() {
    FULL_KEXT_NAME="acidanthera/AppleALC"
    KEXT_NAME="AppleALC"
    download_kext_gh
}

usbinjectall_download() {
    url="https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2018-1108.zip"
    KEXT_NAME="USBInjectAll"
    KEXT_FILENAME="RehabMan-USBInjectAll-2018-1108"
    download_kext_gh_custom
}

main(){
    prepare
    virtualsmc_download
    whatevergreen_download
    lilu_download
    realtek8111_download
    applealc_download
    usbinjectall_download
}

main
