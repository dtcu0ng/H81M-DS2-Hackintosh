#!/bin/bash

#=========================BUILD OC EFI=========================
# Filename: BuildOC.sh
# Version 22.7.20
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==============================================================

check_input() {
    if [ "$TARGET" == "DEBUG" ]; then
        echo Found valid target: $TARGET
        echo "::set-output name=buildtarget::${TARGET}"
    elif [ "$TARGET" == "RELEASE" ]; then
        echo Found valid target: $TARGET
        echo "::set-output name=buildtarget::${TARGET}"
    else
        echo Unvaild target: $TARGET
        exit 1
    fi
}

download_bootloader() {
    echo Cleaning up current EFI...
    rm -rf H81M-DS2-EFI
    rm -rf EFI
    rm -rf DownloadedKexts
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    TAG="${RELEASE_URL##*/}"
    echo "::set-output name=octag::${TAG}"
    url=https://github.com/acidanthera/OpenCorePkg/releases/download/$TAG/OpenCore-$TAG-$TARGET.zip
    echo Downloading OpenCore $TAG $TARGET
    curl -# -L -O "${url}" || exit 1
    unzip -qq "*.zip" || exit 1
    echo "Installed OpenCore version $TAG ($TARGET) and kexts ($TARGET) in CI#$GITHUB_RUN_NUMBER for commit $GITHUB_SHA:" >> installed_compoments.txt
}

make_efi() {
    echo Making standard OpenCore EFI folder...
    cd X64/EFI/OC
    cd Drivers
    find . ! -name 'OpenRuntime.efi' ! -name 'ResetNvramEntry.efi' ! -name "ToggleSipEntry.efi" -delete
    cd ../Tools
    find . ! -name 'OpenShell.efi' -delete
    cd ../../../..
    cp -R X64/EFI EFI
}

copy_stuff() {
    echo Copying SSDTs...
    cp ACPI/SSDT-EC.aml EFI/OC/ACPI
    cp ACPI/SSDT-PLUG.aml EFI/OC/ACPI
    echo Copying HFS driver...
    cp Drivers/HfsPlus.efi EFI/OC/Drivers
    cp installed_compoments.txt EFI/OC
}

copy_config(){
    if [ -d "config/$TAG" ]; then
        echo Copying OpenCore config...
        cp config/$TAG/config_igpu.plist EFI/OC
        cp config/$TAG/config.plist EFI/OC
        cp config/CONFIG_README.txt EFI/OC
    else
        echo "DO NOT USE THIS EFI BUILD UNLESS THERE ARE A COMPATIBLE CONFIG.PLIST PRESENT" >> EFI\OC\WARNING.txt
        echo "::warning::No config for this version ($TAG) present."
        echo "::warning::No file copied. You can't use this EFI unless there is a config.plist present."
    fi
}

cleanup() {
    echo Cleaning up...
    rm -r Docs
    rm -r IA32
    rm -r Utilities
    rm -r X64
    rm OpenCore-$TAG-$TARGET.zip
}

main() {
    check_input
    download_bootloader
    make_efi
    copy_stuff
    copy_config
    cleanup
}

main
