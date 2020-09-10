# H81M-DS2-Hackintosh

Just a Clover folder for mainboard Gigabyte H81M-DS2 (rev3.0)

Guide for OpenCore Pentium CPUs will update soon.

# My PC specification:
+ Mainboard Gigabyte H81M-DS2 (rev3.0)
+ CPU: Intel Pentium G3250 (Haswell, 3,20GHz, 2 core) (FakeCPUID set to 0x0306A9)
+ RAM: 4GB
+ GPU: NVIDIA Geforce GT 730 (GK208B, 128bit, 2GB GDDR5), natively support in Mojave, Catalina.
+ SSD: Kingmax SSD 128GB
+ Network: Realtek RTL8111 (best layout-id in my build is 3)
+ Sound: Realtek ALC887
+ Current macOS installed on this build: macOS High Sierra (17G14019)
+ SMBIOS: iMac14,1 or iMac14,2 (iMac15,1 for Big Sur)

# This specification was run:
+ Lastest Windows 10 build
+ macOS Big Sur Beta 5
+ macOS Catalina
+ macOS Mojave
+ macOS High Sierra

# What is working:
+ Microphone (pink jack input)
+ Speaker (green jack input) 
+ Ethernet (en0)
+ App Store
+ iBooks
+ iCloud Drive
+ Graphics (GT730 is natively support in Catalina, other NVIDIA card please check when install Catalina.)
+ Intel QuickSync/Hardware Acceleration (use SMBIOS iMac14,1 won't work, use iMac14,2 instead)
+ USB 2.0
+ USB 3.0
+ Airdrop (not test yet cuz i don't have external internet/bluetooth card)
+ AirPlay (same as Airdrop)
+ Handoff (same as Airdrop)
+ iMessages (not fix yet)
+ FaceTime (not fix yet)

# Attention:
+ Because macOS don't support Pentium, Celeron CPUs, so we need a fake CPUID for that:
+ In Clover bootloader, press O, go to Binary patching, set the FakeCPUID to: 0x0306A0 or 0x0306A9 (both have been tested by me)
+ Or you can set FakeCPUID in Clover Configurator by going to Kernel and Kext Patches section, set the FakeCPUID to 0x0306A0 or 0x0306A9 (this will save your time when boot installed macOS in your hard drive)
+ SIP was completely disabled on both OC and Clover EFI

# Post-install:
+ (Only High Sierra ) If you have NVIDIA graphics card, use this terminal command to install Web driver

```
bash <(curl -s https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh)
```
Code by [Benjamin-Dobell](https://github.com/Benjamin-Dobell/), use this [link](https://github.com/Benjamin-Dobell/nvidia-update/) to learn more.
+ (Only High Sierra ) I installed CUDA driver too, get this in [here](https://www.nvidia.com/en-us/drivers/cuda/mac-driver-archive/)
+ Don't forget to add nvda_drv=1 in boot-args and select NVIDIAWeb on System Parameters (Clover Configuator)

+ If you have AMD cards, you're natively supported.

# Credit
+ Apple for macOS
+ [hackintosh.vn](https://hackintosh.vn) for Vietnamese guides
+ [Olarila](https://olarila.com) for Clover English guides, configs
+ [Benjamin-Dobell](https://github.com/Benjamin-Dobell/) for NVIDIA Web scripts
+ [Dortania](https://dortania.github.io/OpenCore-Install-Guide/) for OpenCore guides
+ NVIDIA for all the drivers
