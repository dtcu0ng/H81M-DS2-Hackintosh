#!/bin/bash
download_OC() {
    rm -rf EFI
    TARGET="Release"
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    TAG="${RELEASE_URL##*/}"
    url=https://github.com/acidanthera/OpenCorePkg/releases/download/$TAG/OpenCore-$TAG-$TARGET.zip
    curl -# -L -O "${url}" || exit 1
    unzip -qq "*.zip" || exit 1
}

make_efi() {
    cd OpenCore-$TAG-$TARGET
    cd X64/EFI/OC
    cd Drivers
    find . ! -name OpenRuntime.efi -delete
    cd ../Tools
    find . ! -name OpenShell.efi -delete
    cd ../../../../..
    cp -R OpenCore-$TAG-$TARGET/X64/EFI EFI
}

copy_stuff() {
    cp ACPI/SSDT-EC.aml EFI/OC/ACPI
    cp ACPI/SSDT-PLUG.aml EFI/OC/ACPI
    cp configs/$TAG/config.plist EFI/OC
}

main() {
    download_OC
    make_efi
    copy_stuff
}

main