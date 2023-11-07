#!/bin/bash
#==============================================================
# Filename: AnalyzeConfig.sh
# Version 23.11.7
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==============================================================

cleanUp() {
    rm -f ./config/Sample.plist
    rm -rf ./OpenCore
}

compareLocal() {
    releaseURL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    TAG="${releaseURL##*/}"
    echo Downloading latest OpenCore sample config...
    curl -# -L -O "https://raw.githubusercontent.com/acidanthera/OpenCorePkg/$TAG/Docs/Sample.plist" || exit 1
    mv "Sample.plist" "./config/Sample.plist"
    if [ -f "./config/SampleLocal.plist" ]; then
        if [ -f "./config/Sample.plist" ]; then
            if ! cmp -s "./config/SampleLocal.plist" "./config/Sample.plist"; then
                echo "::warning::The sample config is different from the remote config. Please check the differences and update the local config file."
            else
                echo "::notice::Same sample config. That means you may not need to update the config."
            fi
        else
            echo "::error::The remote config file does not exist"
            exit 1
        fi
    else
        echo "::error::The local config does not exist"
        exit 1
    fi
    analyzeConfig
}

analyzeConfig() {
    echo Downloading OpenCore...
    mkdir "OpenCore" && cd "OpenCore" || exit 1
    releaseURL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    TAG="${releaseURL##*/}"
    echo "octag=${TAG}" >> $GITHUB_OUTPUT
    url=https://github.com/acidanthera/OpenCorePkg/releases/download/$TAG/OpenCore-$TAG-RELEASE.zip
    curl -# -L -O "${url}" || exit 1
    unzip -o -qq "*.zip" || exit 1
    chmod +x Utilities/ocvalidate/ocvalidate || exit 1
    cd .. 
    if [ -f "./config/$TAG/config.plist" ]; then
        if [ ! -f "./config/$TAG/config_igpu.plist" ]; then
            echo "::error::The iGPU config file does not exist"
            exit 1
        fi
    else
        echo "::error::The config is not exist"
        exit 1
    fi
    ./OpenCore/Utilities/ocvalidate/ocvalidate ./config/$TAG/config.plist || exit 1
    ./OpenCore/Utilities/ocvalidate/ocvalidate ./config/$TAG/config_igpu.plist || exit 1
}

main() {
    cleanUp
    compareLocal
}

main
