#
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

#
# This is the product configuration for a generic CDMA sholes,
# not specialized for any geography.
#

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

## (1) First, the most specific values, i.e. the aspects that are specific to CDMA

PRODUCT_COPY_FILES += \
    device/motorola/sholes/init.sholes.rc:root/init.sholes.rc \
    device/motorola/sholes/uevent.sholes.rc:root/uevent.sholes.rc

#    device/motorola/sholes/init.rc:root/init.rc \

## (2) Also get non-open-source CDMA-specific aspects if available
$(call inherit-product-if-exists, vendor/motorola/sholes/sholes-vendor.mk)

## (3)  Finally, the least specific parts, i.e. the non-CDMA-specific aspects
PRODUCT_PROPERTY_OVERRIDES += \
	ro.com.android.wifi-watchlist=GoogleGuest \
	ro.error.receiver.system.apps=com.google.android.feedback \
	ro.setupwizard.enterprise_mode=1 \
	ro.com.google.clientidbase=android-verizon \
	ro.com.google.locationfeatures=1 \
	ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
	ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
	ro.cdma.home.operator.numeric=310004 \
	ro.cdma.home.operator.alpha=Verizon \
	ro.cdma.homesystem=64,65,76,77,78,79,80,81,82,83 \
	ro.cdma.data_retry_config=default_randomization=2000,0,0,120000,180000,540000,960000 \
	ro.config.vc_call_vol_steps=7 \
	ro.telephony.call_ring.multiple=false \
	ro.telephony.call_ring.delay=3000 \
	ro.url.safetylegal=http://www.motorola.com/staticfiles/Support/legal/?model=A855 \
	ro.setupwizard.enable_bypass=1 \
	ro.media.dec.jpeg.memcap=20000000 \
    	keyguard.no_require_sim=true \
   	ro.com.android.dataroaming=true \
    	ro.com.android.dateformat=MM-dd-yyyy \
    	ro.config.ringtone=Ring_Synth_04.ogg \
    	ro.config.notification_sound=pixiedust.ogg \
        dalvik.vm.heapstartsize=5m \
        dalvik.vm.heapsize=48m
#        debug.sf.hw=1

#        ro.sf.hwrotation=90 \
#        debug.sf.ddms=1 \

DEVICE_PACKAGE_OVERLAYS += device/motorola/sholes/overlay

PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \


# media config xml file
PRODUCT_COPY_FILES += \
    device/motorola/sholes/media_profiles.xml:system/etc/media_profiles.xml

#key layouts
PRODUCT_COPY_FILES += \
    device/motorola/sholes/qtouch-touchscreen.idc:system/usr/idc/qtouch-touchscreen.idc \
    device/motorola/sholes/qtouch-touchscreen.kl:system/usr/keylayout/qtouch-touchscreen.kl \
    device/motorola/sholes/sholes-keypad.kl:system/usr/keylayout/sholes-keypad.kl \
    device/motorola/sholes/AVRCP.kl:system/usr/keylayouts/AVRCP.kl \
    device/motorola/sholes/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    device/motorola/sholes/sholes-keypad.kcm:system/usr/keychars/sholes-keypad.kcm \
    device/motorola/sholes/sholes-keypad.idc:system/usr/idc/sholes-keypad.idc \
    device/motorola/sholes/cpcap-key.kcm:system/usr/keychars/cpcap-key.kcm
    
PRODUCT_PACKAGES += \
    librs_jni \
    tiwlan.ini \
    dspexec \
    libbridge \
    gps.sholes \
    overlay.omap3 \
    wlan_cu \
    libtiOsLib \
    wlan_loader \
    libCustomWifi \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libOMX.TI.AAC.encode \
    libOMX.TI.AMR.encode \
    libOMX.TI.WBAMR.encode \
    libOMX.TI.JPEG.Encoder \
    libLCML \
    libOMX_Core \
    libOMX.TI.Video.Decoder \
    libOMX.TI.Video.encoder \
    libVendor_ti_omx \
    sensors.sholes \
    lights.sholes \
    hwcomposer.default \
    audio.primary.sholes \
    audio_policy.sholes \
    VoiceDialer \
    drmserver \
    libdrmframework \
    libdrmframework_jni \
    UsbMassStorageToggle \
    Torch \
    liba2dp
#    libfwdlockengine \
#    libWnnEngDic \
#    libwnndict \
#    WAPPushManager

#too big?
#    OpenWnn \
#   VideoEditor \
# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# sholes uses high-density artwork where available
PRODUCT_LOCALES += hdpi

PRODUCT_COPY_FILES += \
    device/motorola/sholes/vold.fstab:system/etc/vold.fstab\
    device/motorola/sholes/apns-conf.xml:system/etc/apns-conf.xml

# copy all kernel modules under the "modules" directory to system/lib/modules
PRODUCT_COPY_FILES += $(shell \
    find device/motorola/sholes/modules -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/motorola/sholes/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

# copy kernel
PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

$(call inherit-product-if-exists, vendor/motorola/sholes/sholes-vendor.mk)

# media profiles and capabilities spec
# $(call inherit-product, device/motorola/sholes/media_a1026.mk)


# Put en_US first in the list, so make it default.
PRODUCT_LOCALES := en_US hdpi

# Get some sounds
$(call inherit-product-if-exists, frameworks/base/data/sounds/OriginalAudio.mk)

# Get the TTS language packs
#$(call inherit-product-if-exists, external/svox/pico/lang/all_pico_languages.mk)

# Get everything else from the parent package
$(call inherit-product-if-exists, build/target/product/generic_no_telephony.mk)

PRODUCT_DEFAULT_LANGUAGE := en_US

PRODUCT_NAME := generic_sholes
PRODUCT_DEVICE := sholes
