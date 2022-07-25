#!/bin/bash
#=========================AnalyzeConfig=========================
# Filename: AnalyzeConfig.sh
# Version 22.7.20
# https://github.com/dtcu0ng/H81M-DS2-Hackintosh
#==============================================================

Cleanup() {
    rm -f ./config/Sample.plist
    rm -rf ./OpenCore
}

CompareLocal() {
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    TAG="${RELEASE_URL##*/}"
    echo Downloading latest OpenCore sample config...
    curl -# -L -O "https://raw.githubusercontent.com/acidanthera/OpenCorePkg/$TAG/Docs/Sample.plist" || exit 1
    mv "Sample.plist" "./config/Sample.plist"
    if [ -f "./config/SampleLocal.plist" ]; then
        if [ -f "./config/Sample.plist" ]; then
            if ! cmp -s "./config/SampleLocal.plist" "./config/Sample.plist"; then
                echo "::warning::The sample config is different from remote config. Please check the differences and update the local config file."
                exit 1
            else
                echo "::notice::Same sample config. That mean you may not need to update the config."
            fi
        else
            echo "::error::The remote config file is not exist"
            exit 1
        fi
    else
        echo "::error::The local config is not exist"
        exit 1
    fi
    AnalyzeConfig
}

AnalyzeConfig() {
    echo Downloading OpenCore...
    mkdir "OpenCore" && cd "OpenCore" || exit 1
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/acidanthera/OpenCorePkg/releases/latest)
    TAG="${RELEASE_URL##*/}"
    echo "::set-output name=octag::${TAG}"
    url=https://github.com/acidanthera/OpenCorePkg/releases/download/$TAG/OpenCore-$TAG-RELEASE.zip
    curl -# -L -O "${url}" || exit 1
    unzip -o -qq "*.zip" || exit 1
    chmod +x Utilities/ocvalidate/ocvalidate || exit 1
    cd .. 
    if [ -f "./config/$TAG/config.plist" ]; then
        if [ ! -f "./config/$TAG/config_igpu.plist" ]; then
            echo "::error::The iGPU config file is not exist"
            exit 1
        fi
    else
        echo "::error::The config is not exist"
        exit 1
    fi
    ./OpenCore/Utilities/ocvalidate/ocvalidate ./config/$TAG/config.plist || exit 1
    ./OpenCore/Utilities/ocvalidate/ocvalidate ./config/$TAG/config_igpu.plist || exit 1
}

Main() {
    Cleanup
    CompareLocal
}

Main
