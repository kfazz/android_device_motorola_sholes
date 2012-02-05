
ifneq ($(BUILD_TINY_ANDROID),true)
ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),sholes)

LOCAL_PATH := $(call my-dir)


include $(CLEAR_VARS)

LOCAL_MODULE := libaudio

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    libmedia \
    libhardware_legacy

ifeq ($TARGET_OS)-$(TARGET_SIMULATOR),linux-true)
LOCAL_LDLIBS += -ldl
endif

ifneq ($(TARGET_SIMULATOR),true)
LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_SRC_FILES += \
    AudioStreamInMotorola.cpp \
    AudioStreamOutMotorola.cpp \
    AudioHardwareMotorola.cpp

LOCAL_CFLAGS += -fno-short-enums

ifeq ($(strip $(TARGET_BOOTLOADER_BOARD_NAME)),sholes)
  LOCAL_CFLAGS += -DUSE_STEREO_IOCTL_FOR_CHANNELS
endif

#LOCAL_STATIC_LIBRARIES += libaudiointerface
LOCAL_STATIC_LIBRARIES += libaudiohw_legacy
ifeq ($(BOARD_HAVE_BLUETOOTH),true)
  LOCAL_SHARED_LIBRARIES += liba2dp
endif

include $(BUILD_SHARED_LIBRARY)

endif # TARGET_BOOTLOADER_BOARD_NAME == sholes
endif # not BUILD_TINY_ANDROID

