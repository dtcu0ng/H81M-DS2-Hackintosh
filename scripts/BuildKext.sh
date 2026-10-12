#!/usr/bin/env bash
#==================================================================
# Filename: BuildKext.sh
# Version: 26.10.12
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==================================================================

set -e

# Configuration variables
EFI_DIR="H81M-DS2-EFI/EFI"
DOWNLOAD_DIR="DownloadedKexts"
INSTALLED_LOG="../EFI/OC/installedCompoments.md"

prepare() {
    mkdir -p "$EFI_DIR/OC/Kexts" "$DOWNLOAD_DIR"
}

# Generic downloader for GitHub releases
# Usage: download_github "repo" "kext_name" "target_filename_format"
download_github() {
    local repo="$1"
    local kext_name="$2"
    local file_pattern="$3" # e.g., "$kext_name-$tag-$TARGET.zip"

    echo "Fetching latest version for $kext_name..."
    local tag
    tag=$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/$repo/releases/latest" | awk -F'/' '{print $NF}')

    local url="https://github.com/$repo/releases/download/$tag/$file_pattern"
    local zip_name="${file_pattern##*/}"

    echo "Downloading $kext_name v$tag..."
    curl -# -L -o "$zip_name" "$url"
    unzip -qq "$zip_name"
    rm "$zip_name"

    echo -e "+ $kext_name @ $tag\n" >> "$INSTALLED_LOG"
    
    # Export tag for copy step if needed
    eval "${kext_name}_TAG='$tag'"
}

# Generic custom downloader (non-standard GitHub or external links)
download_custom() {
    local kext_name="$1"
    local tag="$2"
    local url="$3"
    local zip_name="$4"

    echo "Downloading $kext_name v$tag..."
    curl -# -L -O "$url"
    unzip -qq "$zip_name"
    rm "$zip_name"

    echo -e "+ $kext_name @ $tag\n" >> "$INSTALLED_LOG"
}

download_all_kexts() {
    cd "$DOWNLOAD_DIR" || exit 1

    # 1. Acidanthera Standard Kexts
    for repo in "acidanthera/VirtualSMC" "acidanthera/WhateverGreen" "acidanthera/lilu" "acidanthera/AppleALC"; do
        local name="${repo##*/}"
        download_github "$repo" "$name" "$name-\$tag-$TARGET.zip"
    # Note: Bash dynamic evaluation simplified below for clarity
    done

    # Re-implementing cleanly without complex dynamic scoping loops:
    download_github "acidanthera/VirtualSMC" "VirtualSMC" "VirtualSMC-\$tag-$TARGET.zip"
    download_github "acidanthera/WhateverGreen" "WhateverGreen" "WhateverGreen-\$tag-$TARGET.zip"
    download_github "acidanthera/lilu" "Lilu" "Lilu-\$tag-$TARGET.zip"
    download_github "acidanthera/AppleALC" "AppleALC" "AppleALC-\$tag-$TARGET.zip"

    # 2. Realtek RTL8111
    local rtl_tag
    rtl_tag=$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/Mieze/RTL8111_driver_for_OS_X/releases/latest" | awk -F'/' '{print $NF}')
    download_custom "RealtekRTL8111" "$rtl_tag" \
        "https://github.com/Mieze/RTL8111_driver_for_OS_X/releases/download/$rtl_tag/RealtekRTL8111-$rtl_tag.zip" \
        "RealtekRTL8111-$rtl_tag.zip"
    RTLTag="$rtl_tag" # Save for copying

    # 3. USBInjectAll (Bitbucket / External)
    download_custom "USBInjectAll" "2018-1108" \
        "https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2018-1108.zip" \
        "RehabMan-USBInjectAll-2018-1108.zip"

    cd ..
}

copy_kexts() {
    echo "Copying kexts to EFI..."
    local dest="EFI/OC/Kexts"
    
    cp -R "$DOWNLOAD_DIR/Kexts/VirtualSMC.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/Kexts/SMCProcessor.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/Kexts/SMCSuperIO.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/Kexts/AppleALC.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/Kexts/WhateverGreen.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/Kexts/Lilu.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/$TARGET/USBInjectAll.kext" "$dest/"
    cp -R "$DOWNLOAD_DIR/RealtekRTL8111-$RTLTag/$TARGET/RealtekRTL8111.kext" "$dest/"
}

clean_up() {
    echo "Cleaning up..."
    rm -rf "$DOWNLOAD_DIR"
}

main() {
    prepare
    download_all_kexts
    copy_kexts
    clean_up
    echo "Build completed successfully!"
}

main
