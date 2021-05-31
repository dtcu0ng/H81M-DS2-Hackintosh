#!/bin/bash
prepare() {
    TARGET="Release"
    [ ! -d "DownloadedKexts" ] && mkdir DownloadedKexts
    echo "Installed kexts in CI#$GITHUB_RUN_NUMBER for commit $GITHUB_SHA:" >> ../EFI/OC/installed_kext.txt
    cd DownloadedKexts
}
download_kext_gh() {
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$FULL_KEXT_NAME/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_NAME-$TAG-$TARGET.zip
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_NAME-$TAG-$TARGET.zip" || exit 1
    rm "$KEXT_NAME-$TAG-$TARGET.zip" # clean up
    echo "$KEXT_NAME ($TARGET) version $TAG" >> ../EFI/OC/installed_compoments.txt
}

download_kext_gh_custom() {  # for custom kexts are not have filename formatted with $KEXT_NAME-$TAG-$TARGET.zip or outside GitHub
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_FILENAME.zip" || exit 1
    rm "$KEXT_FILENAME.zip"
    echo "$KEXT_NAME ($TARGET) version $TAG" >> ../EFI/OC/installed_compoments.txt
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
    RTLTAG="${RELEASE_URL##*/}"
    TAG=$RTLTAG
    KEXT_FILENAME=$KEXT_NAME-V$TAG
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_FILENAME.zip
    download_kext_gh_custom
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
    TAG="2018-1108"
    download_kext_gh_custom
}

copy_kext() {
    cd ..
    cp -R DownloadedKexts/Kexts/VirtualSMC.kext EFI/OC/Kexts/VirtualSMC.kext
    cp -R DownloadedKexts/Kexts/SMCProcessor.kext EFI/OC/Kexts/SMCProcessor.kext
    cp -R DownloadedKexts/Kexts/SMCSuperIO.kext EFI/OC/Kexts/SMCSuperIO.kext
    cp -R DownloadedKexts/AppleALC.kext EFI/OC/Kexts/AppleALC.kext
    cp -R DownloadedKexts/WhateverGreen.kext EFI/OC/Kexts/WhateverGreen.kext
    cp -R DownloadedKexts/Lilu.kext EFI/OC/Kexts/Lilu.kext
    cp -R DownloadedKexts/$TARGET/USBInjectAll.kext EFI/OC/Kexts/USBInjectAll.kext
    cp -R DownloadedKexts/RealtekRTL8111-V$RTLTAG/$TARGET/RealtekRTL8111.kext EFI/OC/Kexts/RealtekRTL8111.kext
}

cleanup() {
    rm -r DownloadedKexts
}

main(){
    #cleanup
    prepare
    virtualsmc_download
    whatevergreen_download
    lilu_download
    realtek8111_download
    applealc_download
    usbinjectall_download
    copy_kext
    cleanup
}

main
