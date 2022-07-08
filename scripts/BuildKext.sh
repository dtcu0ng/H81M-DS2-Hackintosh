#!/bin/bash

#=========================DOWNLOAD OC KEXT=========================
# Filename: BuildKext.sh
# Version 22.6.29
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==================================================================

# TODO: use json to store kext name & info
prepare() {
    if [ ! -d "H81M-DS2-EFI" ]; then
        echo "::warning::The EFI directory is not exist. This is abnormal. Please check the CI workflow again, make sure that BuildOC.sh is run before BuildKext.sh"
        echo "::warning::Please be careful when using this EFI."
        echo "Creating EFI directory..."
        mkdir H81M-DS2-EFI
    fi
    if [ ! -d "H81M-DS2-EFI/EFI" ]; then
        echo "::warning::The EFI directory is not exist. This is abnormal. Please check the CI workflow again, make sure that BuildOC.sh is run before BuildKext.sh"
        echo "::warning::Please be careful when using this EFI."
        echo "Creating EFI directory..."
        mkdir H81M-DS2-EFI/EFI
    fi
    [ ! -d "DownloadedKexts" ] && mkdir DownloadedKexts
    cd DownloadedKexts

}

fetch_github_tag(){ # now this is useless, but it will be useful later...
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$REPOSITORY/releases/latest)
    TAG="${RELEASE_URL##*/}"
}

download_kext_gh() {
    url=https://github.com/$REPOSITORY/releases/download/$TAG/$KEXT_NAME-$TAG-$TARGET.zip
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_NAME-$TAG-$TARGET.zip" || exit 1
    rm "$KEXT_NAME-$TAG-$TARGET.zip" # clean up
    echo "+ $KEXT_NAME @ $TAG" >> ../EFI/OC/installed_compoments.txt
}

download_kext_gh_custom() {  # for custom kexts are not have filename formatted with $KEXT_NAME-$TAG-$TARGET.zip or outside GitHub
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_FILENAME.zip" || exit 1
    rm "$KEXT_FILENAME.zip"
    echo "+ $KEXT_NAME @ $TAG" >> ../EFI/OC/installed_compoments.txt
}

virtualsmc_download() {
    REPOSITORY="acidanthera/VirtualSMC"
    KEXT_NAME="VirtualSMC"
    fetch_github_tag
    download_kext_gh
}

whatevergreen_download() {
    REPOSITORY="acidanthera/WhateverGreen"
    KEXT_NAME="WhateverGreen"
    fetch_github_tag
    download_kext_gh
}

lilu_download() {
    REPOSITORY="acidanthera/lilu"
    KEXT_NAME="Lilu"
    fetch_github_tag
    download_kext_gh
}

realtek8111_download() { # hard worked to get this work, i know i'm noob, stfu
    REPOSITORY="Mieze/RTL8111_driver_for_OS_X"
    KEXT_NAME="RealtekRTL8111"
    fetch_github_tag
    RTLTAG=$TAG # we need this to copy kext, cuz extracted of this file are very different.
    KEXT_FILENAME=$KEXT_NAME-V$TAG
    url=https://github.com/$REPOSITORY/releases/download/$TAG/$KEXT_FILENAME.zip
    download_kext_gh_custom
}

applealc_download() {
    REPOSITORY="acidanthera/AppleALC"
    KEXT_NAME="AppleALC"
    fetch_github_tag
    download_kext_gh
}

usbinjectall_download() { # manually update, because releases of this kext are outside GitHub, and it's not updated for almost 3yrs
    url="https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2018-1108.zip"
    KEXT_NAME="USBInjectAll"
    KEXT_FILENAME="RehabMan-USBInjectAll-2018-1108"
    TAG="2018-1108" #this is not necessary, but i added TAG variable for write it to installed_compoments.txt
    download_kext_gh_custom
}


copy_kext() {
    cd ..
    echo Copying kexts...
    cp -R DownloadedKexts/Kexts/VirtualSMC.kext H81M-DS2-EFI/EFI/OC/Kexts/VirtualSMC.kext
    cp -R DownloadedKexts/Kexts/SMCProcessor.kext H81M-DS2-EFI/EFI/OC/Kexts/SMCProcessor.kext
    cp -R DownloadedKexts/Kexts/SMCSuperIO.kext H81M-DS2-EFI/EFI/OC/Kexts/SMCSuperIO.kext
    cp -R DownloadedKexts/AppleALC.kext H81M-DS2-EFI/EFI/OC/Kexts/AppleALC.kext
    cp -R DownloadedKexts/WhateverGreen.kext H81M-DS2-EFI/EFI/OC/Kexts/WhateverGreen.kext
    cp -R DownloadedKexts/Lilu.kext H81M-DS2-EFI/EFI/OC/Kexts/Lilu.kext
    cp -R DownloadedKexts/$TARGET/USBInjectAll.kext H81M-DS2-EFI/EFI/OC/Kexts/USBInjectAll.kext
    cp -R DownloadedKexts/RealtekRTL8111-V$RTLTAG/$TARGET/RealtekRTL8111.kext H81M-DS2-EFI/EFI/OC/Kexts/RealtekRTL8111.kext
}

cleanup() {
    echo Cleaning up...
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
