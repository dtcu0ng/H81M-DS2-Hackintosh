# H81M-DS2-HackintoshClover

Just a Clover folder for mobo Gigabyte H81M-DS2 (rev3.0)

# My spec:
+ CPU: Intel Pentium G3250 (Haswell, 3,20GHz, 2 core)
+ RAM: 4GB
+ GPU: NVIDIA Geforce GT 730 (GK208B, 128bit, 2GB GDDR3), natively support in Mojave, Catalina.
+ SSD: Kingmax SSD 128GB
+ Network: Realtek RTL8111 ALC887 (best layout-id in my build is 3)
+ Sound: Realtek ALC887
+ Current macOS installed on this build: 10.13.6 High Sierra (17G12034)

# This spec was run:
+ Lastest Windows 10 build
+ macOS Catalina
+ macOS Mojave
+ macOS High Sierra

# Attention:
+ Because macOS don't support Pentium, Celeron CPUs, so we need a fake CPUID for that:
+ In Clover bootloader, press O, go to Binary patching, set the FakeCPUID to: 0x0306A0 or 0x0306A9 (both have been tested by me)
+ Or you can set FakeCPUID in Clover Configurator by going to Kernel and Kext Patches section, set the FakeCPUID to 0x0306A0 or 0x0306A9 (this will save your time when boot installed macOS in your hard drive)

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
+ [Olarila](https://olarila.com) for English guides, configs
+ [Benjamin-Dobell](https://github.com/Benjamin-Dobell/) for NVIDIA Web scripts
+ NVIDIA for all the drivers