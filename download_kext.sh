#!/bin/bash
download_kext_gh () {
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$FULL_KEXT_NAME/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/$FULL_KEXT_NAME/releases/download/$TAG/$KEXT_NAME-$TAG-RELEASE.zip
    echo Downloading $KEXT_NAME v$TAG
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$KEXT_NAME-$TAG-RELEASE.zip" || exit 1
}

virtualsmc_download () {
    FULL_KEXT_NAME="acidanthera/VirtualSMC"
    KEXT_NAME="VirtualSMC"
    download_kext_gh
    cp -R Kexts/VirtualSMC.kext ./EFI/OC/Kexts/VirtualSMC.kext
    cp -R Kexts/SMCProcessor.kext ./EFI/OC/Kexts/SMCProcessor.kext
    cp -R Kexts/SMCSuperIO.kext ./EFI/OC/Kexts/SMCSuperIO.kext
    rm -rf Kexts/
    ls
    cd ./EFI/OC/Kexts
    ls
}

virtualsmc_download
