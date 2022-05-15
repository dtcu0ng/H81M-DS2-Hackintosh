## H81M-DS2-HackintoshEFI

OpenCore EFI folder for mainboard Gigabyte H81M-DS2 (rev3.0).


[![GitHub all releases](https://img.shields.io/github/downloads/dtcu0ng/H81M-DS2-Hackintosh/total)](https://github.com/dtcu0ng/H81M-DS2-Hackintosh/releases) [![ocvalidate check](https://github.com/dtcu0ng/H81M-DS2-Hackintosh/workflows/CI/badge.svg)](https://github.com/dtcu0ng/H81M-DS2-Hackintosh/actions)

English | [Vietnamese](README_vi.md)

| Current installed  | OS(es) |
| ------------- | ------------- |
| ✅  | Windows 10  |
| ✅  | macOS Catalina |

- [x] Windows 10
- [x] macOS Catalina

## My PC specification

| Part  | Info |
| ------------- | ------------- |
| Mainboard | Gigabyte H81M-DS2 (rev3.0), BIOS version F3  |
| CPU:  | Intel Xeon E3-1220 v3 (Haswell, 3,10 GHZ up to 3,50GHz, 4 core 4 thread)  |
| RAM:  | 8GB (2x4GB)  |
| GPU:  | NVIDIA Geforce GT 730 (GK208B, 128bit, 2GB GDDR5), natively support in Mojave, Catalina. (*) |
| Disk:  | Netac SSD 128GB, WD Blue 256GB  |
| Network: | Realtek RTL8111 |
| Sound:  | Realtek ALC887 (best layout-id in my build is 3)  |
| SMBIOS:  | iMac15,1  |


| Windows  | macOS |
| ------------- | ------------- |
| ![dxdiag windows spec](images/systeminfo_win.png "System specfication") | ![hackintool spec](images/systeminfo_mac.png "System specfication")  |

## This specification was run

| Status  | Operating System & Version |
| ------------- | ------------- |
| ✅  | Windows 10  |
| ✅  | macOS Monterey Beta 1* |
| ✅  | macOS Big Sur  |
| ✅  | macOS Catalina |
| ✅  | macOS Mojave  |
| ✅  | macOS High Sierra  |
| ✅  | macOS Sierra  |
| ✅  | Mac OS X El Captain  |

- [x] Windows 10
- [x] macOS Monterey Beta 1*
- [x] macOS Big Sur
- [x] macOS Catalina
- [x] macOS Mojave
- [x] macOS High Sierra
- [x] macOS Sierra
- [x] Mac OS X El Captain

Notes:
(*): macOS 12 Monterey does not support iMac15,1 or older SMBIOS, use iMac16,1 (if you only have iGPU) or iMac17,1 (if you have dGPU) and add -lilubetaall to boot-args.

(*): Apple dropped support for Kepler NVIDIA grapics card since Monterey Beta 7, so you need be cautious, if you in Monterey < Beta 6, don't update to Beta 7 or just go back to earlier version like Big Sur, Catalina,...

## What is working
| Status  | Functions: |
| ------------- | ------------- |
| ✅  | Microphone (pink jack input)  |
| ✅  | Speaker (green jack input)  |
| ✅  | Ethernet (en0)  |
| ✅  | Services (App Store, Apple Music,...) |
| ✅  | Graphics card* |
| ✅  | Intel QuickSync/Hardware Acceleration |
| ✅  | USB 2.0/3.0  |
| ✅  | Bootcamp** |

- [x] Microphone (pink jack input)
- [x] Speaker (green jack input)
- [x] Ethernet (en0)
- [x] Services (App Store, Apple Music,...)
- [x] Graphics card*
- [x] Intel QuickSync/Hardware Acceleration
- [x] USB 2.0/3.0
- [x] Bootcamp**

Notes: 
(*): GT730 (Kepler) is natively support in Catalina, other NVIDIA card please check before install Mojave or above.

(*): You may have screen flickering sometimes, add agdpmod=pikera in boot-arg may fix it. 

(**): If Bootcamp don't work in your machine, you need select another OS disk in UEFI settings to boot another OS.

## Guide for Low-end CPUs (Pentium, Celeron)
+ Because macOS don't support Pentium, Celeron CPUs, so we need a use the Fake CPUID and some changes, patches for that CPU to boot in MacOS:

Tutorial:
+ In your config.plist, goto Kernel > Emulate add these data into require value
```
Cpuid1Data: A9060300 00000000 00000000 00000000
Cpuid1Mask: FFFFFFFF 00000000 00000000 00000000
```
+ Set Kernel > Emulate > DummyPowerManagement to Enabled/True
+ Set NVRAM > WriteFlash to Disabled/False
+ Replace HFSPlus.efi to [HFSPlusLegacy.efi](https://github.com/acidanthera/OcBinaryData/blob/master/Drivers/HfsPlusLegacy.efi)
+ Don't forget to take an OC Snapshot in ProperTree after you work with files!
+ Some problem are described/fix like this [Reddit](https://www.reddit.com/r/hackintosh/comments/gn41rk/stuck_in_oc_watchdog_status_is_0/) post.

## How to download EFI:
| DON'T use this  | Use this | And this |
| ------------- | ------------- | ------------- |
| ![don't use this](images/dont_use_this_to_download.png "Don't use this") | ![use this](images/use_this.png "Use this") | ![and this](images/and_this.png "and this") |

## Post-install:
+ (Only High Sierra) If you have NVIDIA graphics card, use this terminal command to install Web driver

```
bash <(curl -s https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh)
```
Code by [Benjamin-Dobell](https://github.com/Benjamin-Dobell/), use this [link](https://github.com/Benjamin-Dobell/nvidia-update/) to learn more.
+ (Only High Sierra) I installed CUDA driver too, get this in [here](https://www.nvidia.com/en-us/drivers/cuda/mac-driver-archive/)

## Thanks
+ [hackintosh.vn](https://hackintosh.vn) for Vietnamese guides
+ [Olarila](https://olarila.com) for English guides, configs
+ [Benjamin-Dobell](https://github.com/Benjamin-Dobell/) for NVIDIA Web scripts
+ [Dortania](https://dortania.github.io/OpenCore-Install-Guide/) for OpenCore guides
