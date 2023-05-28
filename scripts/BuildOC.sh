#!/bin/bash

#=========================BUILD OC EFI=========================
# Filename: BuildOC.sh
# Version 22.7.20
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==============================================================

checkInput() {
    if [ "$TARGET" == "DEBUG" ]; then
        echo Found valid target: $TARGET
        echo "buildTarget=${TARGET}" >> $GITHUB_OUTPUT
    elif [ "$TARGET" == "RELEASE" ]; then
        echo Found valid target: $TARGET
        echo "buildTarget=${TARGET}" >> $GITHUB_OUTPUT
    else
        echo Unvaild target: $TARGET
        exit 1
    fi
}

downloadBootloader() {
    echo Cleaning up current EFI...
    rm -rf H81M-DS2-EFI
    rm -rf EFI
    rm -rf DownloadedKexts
    releaseURL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    tag="${releaseURL##*/}"
    echo "octag=${tag}" >> $GITHUB_OUTPUT
    url=https://github.com/acidanthera/OpenCorePkg/releases/download/$tag/OpenCore-$tag-$TARGET.zip
    echo Downloading OpenCore $tag $TARGET
    curl -# -L -O "${url}" || exit 1
    unzip -qq "*.zip" || exit 1
    echo "Installed OpenCore version $tag ($TARGET) and kexts ($TARGET) in CI#$GITHUB_RUN_NUMBER for commit $GITHUB_SHA:" >> installedCompoments.txt
}

makeEFI() {
    echo Making standard OpenCore EFI folder...
    cd X64/EFI/OC
    cd Drivers
    find . ! -name 'OpenRuntime.efi' ! -name 'ResetNvramEntry.efi' ! -name "ToggleSipEntry.efi" -delete
    cd ../Tools
    find . ! -name 'OpenShell.efi' -delete
    cd ../../../..
    cp -R X64/EFI EFI
}

copyStuff() {
    echo Copying SSDTs...
    cp ACPI/SSDT-EC.aml EFI/OC/ACPI
    cp ACPI/SSDT-PLUG.aml EFI/OC/ACPI
    echo Copying HFS driver...
    cp Drivers/HfsPlus.efi EFI/OC/Drivers
    cp installedCompoments.txt EFI/OC
}

copyConfig(){
    if [ -d "config/$tag" ]; then
        echo Copying OpenCore config...
        cp config/$tag/config_igpu.plist EFI/OC
        cp config/$tag/config.plist EFI/OC
        cp config/CONFIG_README.txt EFI/OC
    else
        echo "DO NOT USE THIS EFI BUILD UNLESS THERE ARE A COMPATIBLE CONFIG.PLIST PRESENT" >> EFI\OC\WARNING.txt
        echo "::warning::0 file copied because no config for this version ($tag) present. You can't use this EFI unless there is a config.plist suitable for version $tag"
    fi
}

cleanUp() {
    echo Cleaning up...
    rm -r Docs
    rm -r IA32
    rm -r Utilities
    rm -r X64
    rm OpenCore-$tag-$TARGET.zip
}

main() {
    checkInput
    downloadBootloader
    makeEFI
    copyStuff
    copyConfig
    cleanUp
}

main
