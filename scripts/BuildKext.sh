#!/bin/bash

#=========================DOWNLOAD OC KEXT=========================
# Filename: BuildKext.sh
# Version 22.7.20
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==================================================================

# TODO: use json to store kext name & info
prepare() {
    [ ! -d "H81M-DS2-EFI" ] && mkdir "H81M-DS2-EFI"
    [ ! -d "H81M-DS2-EFI/EFI" ] && mkdir "H81M-DS2-EFI/EFI"
    [ ! -d "DownloadedKexts" ] && mkdir DownloadedKexts
    cd DownloadedKexts

}

fetchGithubtag(){ # now this is useless, but it will be useful later...
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/$repository/releases/latest)
    tag="${RELEASE_URL##*/}"
}

downloadKextGithub() {
    url=https://github.com/$repository/releases/download/$tag/$kextName-$tag-$TARGET.zip
    echo Downloading $kextName v$tag
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$kextName-$tag-$TARGET.zip" || exit 1
    rm "$kextName-$tag-$TARGET.zip" # clean up
    echo "+ $kextName @ $tag" >> ../EFI/OC/installed_compoments.txt
}

downloadKextGithubCustom() {  # for custom kexts are not have filename formatted with $kextName-$tag-$TARGET.zip or outside GitHub
    echo Downloading $kextName v$tag
    curl -# -L -O "${url}" || exit 1
    unzip -qq "$kextFilename.zip" || exit 1
    rm "$kextFilename.zip"
    echo "+ $kextName @ $tag" >> ../EFI/OC/installed_compoments.txt
}

virtualsmcDownload() {
    repository="acidanthera/VirtualSMC"
    kextName="VirtualSMC"
    fetchGithubtag
    downloadKextGithub
}

whatevergreenDownload() {
    repository="acidanthera/WhateverGreen"
    kextName="WhateverGreen"
    fetchGithubtag
    downloadKextGithub
}

liluDownload() {
    repository="acidanthera/lilu"
    kextName="Lilu"
    fetchGithubtag
    downloadKextGithub
}

realtek8111Download() { # hard worked to get this work, i know i'm noob, stfu
    repository="Mieze/RTL8111_driver_for_OS_X"
    kextName="RealtekRTL8111"
    fetchGithubtag
    RTLtag=$tag # we need this to copy kext, cuz extracted of this file are very different.
    kextFilename=$kextName-V$tag
    url=https://github.com/$repository/releases/download/$tag/$kextFilename.zip
    downloadKextGithubCustom
}

applealcDownload() {
    repository="acidanthera/AppleALC"
    kextName="AppleALC"
    fetchGithubtag
    downloadKextGithub
}

usbinjectallDownload() { # manually update, because releases of this kext are outside GitHub, and it's not updated for almost 3yrs
    url="https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2018-1108.zip"
    kextName="USBInjectAll"
    kextFilename="RehabMan-USBInjectAll-2018-1108"
    tag="2018-1108" #this is not necessary, but i added tag variable for write it to installed_compoments.txt
    downloadKextGithubCustom
}


copyKext() {
    cd ..
    echo Copying kexts...
    cp -R DownloadedKexts/Kexts/VirtualSMC.kext EFI/OC/Kexts/VirtualSMC.kext
    cp -R DownloadedKexts/Kexts/SMCProcessor.kext EFI/OC/Kexts/SMCProcessor.kext
    cp -R DownloadedKexts/Kexts/SMCSuperIO.kext EFI/OC/Kexts/SMCSuperIO.kext
    cp -R DownloadedKexts/AppleALC.kext EFI/OC/Kexts/AppleALC.kext
    cp -R DownloadedKexts/WhateverGreen.kext EFI/OC/Kexts/WhateverGreen.kext
    cp -R DownloadedKexts/Lilu.kext EFI/OC/Kexts/Lilu.kext
    cp -R DownloadedKexts/$TARGET/USBInjectAll.kext EFI/OC/Kexts/USBInjectAll.kext
    cp -R DownloadedKexts/RealtekRTL8111-V$RTLtag/$TARGET/RealtekRTL8111.kext EFI/OC/Kexts/RealtekRTL8111.kext
}

lastStep() {
    mv EFI/* H81M-DS2-EFI/EFI/
}

cleanUp() {
    echo Cleaning up...
    rm -r DownloadedKexts
}

main(){
    #cleanup
    prepare
    virtualsmcDownload
    whatevergreenDownload
    liluDownload
    realtek8111Download
    applealcDownload
    usbinjectallDownload
    copyKext
    cleanUp
    lastStep
}

main
