# H81M-DS2-HackintoshEFI

OpenCore EFI folder for mainboard Gigabyte H81M-DS2 (rev3.0)

| Current installed  | OS(es) |
| ------------- | ------------- |
| ✅  | Latest Windows 10 Insider Preview build  |
| ✅  | macOS Catalina |

# My PC specification

| Part  | Info |
| ------------- | ------------- |
| Mainboard | Gigabyte H81M-DS2 (rev3.0)  |
| CPU:  | Intel Pentium G3250 (Haswell Refresh, 3,20GHz, 2 core) (FakeCPUID set to 0x0306A9)  |
| RAM:  | 8GB (2x4GB)  |
| GPU:  | NVIDIA Geforce GT 730 (GK208B, 128bit, 2GB GDDR5), natively support in Mojave, Catalina. |
| Disk:  | Netac SSD 128GB (macOS 10.15.7 installed, WD Blue 256GB (Windows 10 Insider Preview installed)  |
| Network: | Realtek RTL8111 |
| Sound:  | Realtek ALC887 (best layout-id in my build is 3)  |
| SMBIOS:  | iMac15,1  |

# This specification was run

| Status  | Operating System & Version |
| ------------- | ------------- |
| ✅  | Latest Windows 10 build  |
| ✅  | macOS Big Sur  |
| ✅  | macOS Big Sur Beta 5  |
| ✅  | macOS Catalina |
| ✅  | macOS Mojave  |
| ✅  | macOS High Sierra  |
| ✅  | macOS Sierra  |
| ✅  | Mac OS X El Captain  |

# What is working
| Status  | Functions: |
| ------------- | ------------- |
| ✅  | Microphone (pink jack input)  |
| ✅  | Speaker (green jack input)  |
| ✅  | Ethernet (en0)  |
| ✅  | Services (App Store, iMessages, Facetime,...) |
| ✅  | Graphics card* |
| ✅  | Intel QuickSync/Hardware Acceleration |
| ✅  | USB 2.0/3.0  |
| ✅  | Mac OS X El Captain  |

Notes: 
(*): GT730 (Kepler) is natively support in Catalina, other NVIDIA card please check before install Catalina.

# Not working
| Status  | Functions: |
| ------------- | ------------- |
| ❌  | Bootcamp***  |

Notes:
(***): I need select another OS disk in UEFI settings to boot another OS.

# Guide for Pentium
+ Because macOS don't support Pentium, Celeron CPUs, so we need a use the Fake CPUID patches for that CPU to boot in MacOS:

Tutorial:
+ In your config.plist, goto Kernel > Emulate add these data into require value
```
CpuidData: A9060300 00000000 00000000 00000000
CpuidMask: FFFFFFFF 00000000 00000000 00000000
```

# Big notes
+ DummyPowerManagement is ENABLED, this is not follow the Vanilia OC Guide (because my CPU require the function like NullCPUPowerManagement.kext to boot in, if you have any issues disable DummyPowerManagement in OC config.plist at Kernel > Emulate
+ NVRAM > Writeflash is DISABLED, this is not follow the Vanilia OC Guide (I don't know why this need to disabled, if not, the bootloader hang in OC: Watchdog status is 0. Change this value if your hack have issues.)
+ I'm using HFSPlusLegacy.efi instead of HFSPlus.efi (the same problem with NVRAM > Writeflash, mentioned above.)
+ Some problem are described/fix like this [Reddit](https://www.reddit.com/r/hackintosh/comments/gn41rk/stuck_in_oc_watchdog_status_is_0/) post.

# Post-install:
+ (Only High Sierra) If you have NVIDIA graphics card, use this terminal command to install Web driver

```
bash <(curl -s https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh)
```
Code by [Benjamin-Dobell](https://github.com/Benjamin-Dobell/), use this [link](https://github.com/Benjamin-Dobell/nvidia-update/) to learn more.
+ (Only High Sierra) I installed CUDA driver too, get this in [here](https://www.nvidia.com/en-us/drivers/cuda/mac-driver-archive/)

# Credit
+ [hackintosh.vn](https://hackintosh.vn) for Vietnamese guides
+ [Olarila](https://olarila.com) for English guides, configs
+ [Benjamin-Dobell](https://github.com/Benjamin-Dobell/) for NVIDIA Web scripts
+ [Dortania](https://dortania.github.io/OpenCore-Install-Guide/) for OpenCore guides
