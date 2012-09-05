# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# WARNING: This line must come *before* including the proprietary
# variant, so that it gets overwritten by the parent (which goes
# against the traditional rules of inheritance).
USE_CAMERA_STUB := false

TARGET_PROVIDES_LIBAUDIO := true
# Use a smaller subset of system fonts to keep image size lower
SMALLER_FONT_FOOTPRINT := true

# WARNING: This line must come *before* including the proprietary
# variant, so that it gets overwritten by the parent (which goes
# against the traditional rules of inheritance).

#Camera Fixes

BOARD_USES_CAMERASHIM := true
BOARD_CAMERA_LIBRARIES := libcamera
BOARD_CAMERA_MOTOROLA_COMPAT := true
BOARD_USE_FROYO_LIBCAMERA := true
BOARD_OVERLAY_BASED_CAMERA_HAL := true

USE_TI_COMMANDS:= true

TARGET_NO_BOOTLOADER := true
#TARGET_NO_RADIOIMAGE := true
# BOARD_HAS_SMALL_RECOVERY := true

BOARD_USE_YUV422I_DEFAULT_COLORFORMAT := true

# inherit from the proprietary version
-include vendor/motorola/sholes/BoardConfigVendor.mk

#TARGET_BOARD_PLATFORM := omap3

ARCH_ARM_HAVE_ARMV7A := true
#TARGET_CPU_ABI := armeabi-v7a
#TARGET_CPU_ABI2 := armeabi
#TARGET_ARCH_VARIANT := armv7-a-neon
ARCH_ARM_HAVE_NEON := true
#ARCH_ARM_HAVE_TLS_REGISTER := true #requires HAS_TLS_REG in kernel config

TARGET_BOARD_PLATFORM := omap3
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
TARGET_OMAP3 := true
#COMMON_GLOBAL_CFLAGS += -DTARGET_OMAP3 -DOMAP_COMPAT -DBINDER_COMPAT
ARCH_ARM_HAVE_TLS_REGISTER := true


#TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8
#TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8
#when everyhting else is ok benchmark and compare these
#TARGET_GLOBAL_CFLAGS += -O3 -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -fmodulo-sched -fmodulo-sched-allow-regmoves
#TARGET_GLOBAL_CPPFLAGS += -O3 -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -fmodulo-sched -fmodulo-sched-allow-regmoves

#TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
#TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
#TARGET_arm_CFLAGS := -O3 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops \
# -fmodulo-sched -fmodulo-sched-allow-regmoves
#TARGET_thumb_CFLAGS := -mthumb \
# -Os \
# -fomit-frame-pointer \
# -fstrict-aliasing
#TARGET_TOOLS_PREFIX=/home/ken/linaro/android-toolchain-eabi/bin/arm-linux-androideabi-

#legacy ril
BOARD_USES_LEGACY_RIL := true


##necessary?
TARGET_PROVIDES_INIT_TARGET_RC := true
TARGET_PROVIDES_INIT_RC := true

# audio stuff
TARGET_PROVIDES_LIBAUDIO := true 
BOARD_USES_GENERIC_AUDIO := false  
BOARD_USES_AUDIO_LEGACY := true

#BOARD_USES_ALSA_AUDIO := true
#BUILD_WITH_ALSA_UTILS := true
#BOARD_USES_TI_OMAP_MODEM_AUDIO := true
#BUILD_SHOLES_AUDIO := false #needs lots more work 

# HW Graphics (EGL fixes + webkit fix)
USE_OPENGL_RENDERER := true
DEFAULT_FB_NUM := 0
BOARD_USES_OVERLAY := true
BOARD_EGL_CFG := device/motorola/sholes/egl.cfg
ENABLE_WEBGL := true

#COMMON_GLOBAL_CFLAGS += -DMISSING_EGL_EXTERNAL_IMAGE -DMISSING_EGL_PIXEL_FORMAT_YV12 -DMISSING_GRALLOC_BUFFERS -DEGL_ALWAYS_ASYNC
BOARD_NO_RGBX_8888 := true

#touchscreen fix
BOARD_USE_LEGACY_TOUCHSCREEN := true
OMAP_ENHANCEMENT := true

TARGET_OMAP3 := true

COMMON_GLOBAL_CFLAGS += -DTARGET_OMAP3 -DOMAP_COMPAT -DMOTOROLA_UIDS -DBINDER_COMPAT

HARDWARE_OMX := true  
TARGET_USE_OMAP_COMPAT  := true
BUILD_WITH_TI_AUDIO := 1
BUILD_PV_VIDEO_ENCODERS := 1

BOARD_HAVE_GPS := true
BOARD_USES_GPSSHIM := true

TARGET_BOOTLOADER_BOARD_NAME := sholes

# use pre-kernel.35 vold usb mounting (useless, not in ics)
BOARD_USE_USB_MASS_STORAGE_SWITCH := true  

TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/usb_mass_storage/lun0/file"

ENABLE_SENSORS_COMPAT := true

# Wifi related defines
BOARD_WLAN_DEVICE := wl1271
WPA_SUPPLICANT_VERSION := VER_0_6_X
BOARD_WPA_SUPPLICANT_DRIVER := CUSTOM
WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/tiwlan_drv.ko"
WIFI_DRIVER_MODULE_NAME := tiwlan_drv
WIFI_DRIVER_FW_STA_PATH := "/system/etc/wifi/fw_wlan1271.bin"
WIFI_FIRMWARE_LOADER := wlan_loader
PRODUCT_WIRELESS_TOOLS := true
BOARD_SOFTAP_DEVICE := wl1271
AP_CONFIG_DRIVER_WILINK := true
WIFI_DRIVER_FW_AP_PATH := "/system/etc/wifi/fw_tiwlan_ap.bin"
WPA_SUPPL_APPROX_USE_RSSI := true
WPA_SUPPL_WITH_SIGNAL_POLL := true
# CM9
WIFI_DRIVER_LOADER_DELAY := 200000
WIFI_AP_DRIVER_MODULE_PATH := "/system/lib/modules/tiap_drv.ko"
WIFI_AP_DRIVER_MODULE_NAME := tiap_drv
WIFI_AP_FIRMWARE_LOADER := wlan_ap_loader
WIFI_AP_DRIVER_MODULE_ARG := ""
BOARD_HOSTAPD_SERVICE_NAME := hostap_netd
BOARD_HOSTAPD_NO_ENTROPY := true
BOARD_HOSTAPD_DRIVER := true
BOARD_HOSTAPD_DRIVER_NAME := wilink
BOARD_HOSTAPD_TIAP_ROOT := system/wlan/ti/WiLink_AP
BOARD_SOFTAP_DEVICE_TI := true

TARGET_KERNEL_CONFIG := sholes_defconfig
TARGET_KERNEL_SOURCE := kernel/motorola/sholes
TARGET_KERNEL_CUSTOM_TOOLCHAIN := android-toolchain-eabi
 # arm-eabi-4.4.3


# Connectivity - Wi-Fi
#USES_TI_MAC80211 := true
#ifdef USES_TI_MAC80211
#BOARD_WPA_SUPPLICANT_DRIVER := NL80211
#WPA_SUPPLICANT_VERSION := VER_0_8_X
#BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
#BOARD_WLAN_DEVICE := wl12xx_mac80211
#BOARD_SOFTAP_DEVICE := wl12xx_mac80211
#WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/wl12xx_spi.ko"
#WIFI_DRIVER_MODULE_NAME := "wl12xx_spi"
#WIFI_FIRMWARE_LOADER := ""
#COMMON_GLOBAL_CFLAGS += -DUSES_TI_MAC80211
#endif

#TARGET_MODULES_SOURCE := "hardware/ti/wlan/mac80211/compat_wl12xx"
#
#WIFI_MODULES:
#	make -C $(TARGET_MODULES_SOURCE) KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) KLIB_BUILD=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) #$(ARM_CROSS_COMPILE)
#	mv $(KERNEL_OUT)/lib/crc7.ko $(KERNEL_MODULES_OUT)
#	mv hardware/ti/wlan/mac80211/compat_wl12xx/compat/compat.ko $(KERNEL_MODULES_OUT)
#	mv hardware/ti/wlan/mac80211/compat_wl12xx/net/mac80211/mac80211.ko $(KERNEL_MODULES_OUT)
#	mv hardware/ti/wlan/mac80211/compat_wl12xx/net/wireless/cfg80211.ko $(KERNEL_MODULES_OUT)
#	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx.ko $(KERNEL_MODULES_OUT)
#	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx_spi.ko $(KERNEL_MODULES_OUT)
#
#TARGET_KERNEL_MODULES := WIFI_MODULES




BOARD_KERNEL_CMDLINE := console=ttyS2,115200n8 rw mem=244M@0x80C00000 init=/init ip=off brdrev=P3A_CDMA mtdparts=omap2-nand.0:640k@128k(mbm),384k@1408k(cdt),384k@3328k(lbl),384k@6272k(misc),3584k(boot),4608k(recovery),143744k(system),94848k(cache),268032k(userdata),2m(kpanic)
BOARD_KERNEL_BASE := 0x10000000

BOARD_HAVE_BLUETOOTH := true
TARGET_CUSTOM_BLUEDROID := ../../../device/motorola/sholes/bluedroid.c

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x00380000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x00480000
#BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x08c60000 # actual size! ~140mb
#BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x08c60000 # actual size! ~140mb
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0xAA000000 #fake 170 and trim by hand
BOARD_FLASH_BLOCK_SIZE := 131072

#TARGET_RECOVERY_UI_LIB := librecovery_ui_sholes librecovery_ui_generic

#TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_generic
#TARGET_NO_RECOVERY := true #disables otapackage

USE_SHOLES_PROPERTY := true
TARGET_SKIA_USE_MORE_MEMORY := false

TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/usb_mass_storage/lun0/file"

#KERNEL_DEFCONFIG := cyanogen_sholes_defconfig

# TARGET_PREBUILT_KERNEL := device/motorola/sholes/kernel
# TARGET_PREBUILT_RECOVERY_KERNEL := device/motorola/sholes/recovery_kernel

#adb has root
ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0

