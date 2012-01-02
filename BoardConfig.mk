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

# Use a smaller subset of system fonts to keep image size lower
SMALLER_FONT_FOOTPRINT := true

# WARNING: This line must come *before* including the proprietary
# variant, so that it gets overwritten by the parent (which goes
# against the traditional rules of inheritance).
USE_CAMERA_STUB := true
#BOARD_USE_FROYO_LIBCAMERA := true
#BOARD_USES_TI_CAMERA_HAL := true

USE_TI_COMMANDS:= true

TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
#TARGET_NO_KERNEL := true
TARGET_NO_RADIOIMAGE := true



BOARD_USE_YUV422I_DEFAULT_COLORFORMAT := true

# inherit from the proprietary version
-include vendor/motorola/sholes/BoardConfigVendor.mk

TARGET_BOARD_PLATFORM := omap3

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8
#when everyhting else is ok benchmark and compare these
#TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
#TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=soft

ARCH_ARM_HAVE_TLS_REGISTER := false #check this, apparently omap3430 has the register but kernel doesn't use it



##necessary?
TARGET_PROVIDES_INIT_TARGET_RC := true
TARGET_PROVIDES_INIT_RC := false

# audio stuff
TARGET_PROVIDES_LIBAUDIO := true 
BOARD_USES_GENERIC_AUDIO := false  #testinggg
BOARD_USES_ALSA_AUDIO := false #we have /dev/snd/mixer, is it alsa? testing...
BUILD_WITH_ALSA_UTILS := false
BOARD_USES_AUDIO_LEGACY := true
BOARD_USES_TI_OMAP_MODEM_AUDIO := true


# HW Graphics (EGL fixes + webkit fix)
USE_OPENGL_RENDERER := false
BOARD_EGL_CFG := device/motorola/sholes/egl.cfg

#-DMISSING_EGL_PIXEL_FORMAT_YV12
COMMON_GLOBAL_CFLAGS += -DMISSING_EGL_EXTERNAL_IMAGE -DMISSING_GRALLOC_BUFFERS \
			-DBOARD_GL_OES_EGL_IMG_EXTERNAL_HACK 

BOARD_EGL_GRALLOC_USAGE_FILTER := true
BOARD_NO_RGBX_8888 := true



#touchscreen fix
BOARD_USE_LEGACY_TOUCHSCREEN := true
OMAP_ENHANCEMENT := true

TARGET_OMAP3 := true

COMMON_GLOBAL_CFLAGS += -DTARGET_OMAP3 -DOMAP_COMPAT -DMOTOROLA_UIDS



HARDWARE_OMX := true  #check this too
TARGET_USE_OMAP_COMPAT  := true
BUILD_WITH_TI_AUDIO := 1
BUILD_PV_VIDEO_ENCODERS := 1

#BOARD_HAVE_GPS := true
BOARD_GPS_LIBRARIES := libmoto_gps
BOARD_USES_GPSSHIM := true
 #maybe??
TARGET_BOOTLOADER_BOARD_NAME := sholes

# use pre-kernel.35 vold usb mounting
BOARD_USE_USB_MASS_STORAGE_SWITCH := true


#BOARD_USE_KINETO_COMPATIBILITY := true #what's this do???

TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/usb_mass_storage/lun0/file"

ENABLE_SENSORS_COMPAT := true

# Wifi related defines
#BOARD_WPA_SUPPLICANT_DRIVER := CUSTOM
#BOARD_WPA_SUPPLICANT_PRIVATE_LIB := libCustomWifi
#WPA_SUPPLICANT_VERSION      := VER_0_6_X
#BOARD_WLAN_DEVICE           := tiwlan0
#WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/tiwlan_drv.ko"
#BOARD_WLAN_TI_STA_DK_ROOT   := system/wlan/ti/wilink_6_1
#WIFI_DRIVER_MODULE_ARG      := ""
#WIFI_DRIVER_MODULE_NAME     := "tiwlan_drv"
#WIFI_FIRMWARE_LOADER        := "wlan_loader"

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


BOARD_KERNEL_CMDLINE := console=ttyS2,115200n8 rw mem=244M@0x80C00000 init=/init ip=off brdrev=P3A_CDMA mtdparts=omap2-nand.0:640k@128k(mbm),384k@1408k(cdt),384k@3328k(lbl),384k@6272k(misc),3584k(boot),4608k(recovery),143744k(system),94848k(cache),268032k(userdata),2m(kpanic)
BOARD_KERNEL_BASE := 0x10000000

BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

BOARD_EGL_CFG := device/motorola/sholes/egl.cfg

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x00380000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x00480000 
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x08c60000   # limited so we enforce room to grow
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0x105c0000
BOARD_FLASH_BLOCK_SIZE := 131072

#TARGET_NO_RECOVERY := true # causes no rule to make otapackage
#TARGET_OTA_NO_RECOVERY := true
#???
INSTALLED_RECOVERYIMAGE_TARGET := 
BOARD_HAS_SMALL_RECOVERY := true

#TARGET_RECOVERY_UI_LIB := librecovery_ui_sholes librecovery_ui_generic

#TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_generic

USE_SHOLES_PROPERTY := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/usb_mass_storage/lun0/file"

#KERNEL_DEFCONFIG := cyanogen_sholes_defconfig

TARGET_PREBUILT_KERNEL := device/motorola/sholes/kernel
TARGET_PREBUILT_RECOVERY_KERNEL := device/motorola/sholes/recovery_kernel


