#include <CameraHardwareInterface.h>
#include <utils/RefBase.h>
#include <utils/threads.h>
#include <hardware/camera.h>
#include <hardware/hardware.h>
#include <utils/Log.h>
#include <ui_Overlay.h>

static android::Mutex gCameraHalDeviceLock;
extern "C" int HAL_getNumberOfCameras(){return 1;};

namespace android {
    extern "C" sp<CameraHardwareInterface> HAL_openCameraHardware(int cameraId);
  
    typedef struct shim_camera_device_t {
        camera_device_t base;
        sp<CameraHardwareInterface> hardware;
        int preview_enabled;
        camera_data_callback data_cb;
        camera_data_timestamp_callback data_cb_timestamp;
        void* user;
    };

    /*******************************************************************
     * implementation of camera_device_ops functions
     *******************************************************************/

    int camera_set_preview_window(struct camera_device * device,
            struct preview_stream_ops *window)
    {
        return 0;
    }
    
    void camera_release_memory_shim(struct camera_memory *mem)
    {
    }
    
    void data_callback_shim(int32_t msgType,
                            const sp<IMemory> &dataPtr,
                            camera_frame_metadata_t *metadata,
                            void* user)
    {
        struct camera_memory memory;
        memory.data = dataPtr->pointer();
        memory.size = dataPtr->size();
        memory.handle = NULL;
        memory.release = camera_release_memory_shim;
        shim_camera_device_t* shim_device = (shim_camera_device_t*)user;
        shim_device->data_cb(msgType, &memory, 0, NULL, shim_device->user);        
    }

    void data_callback_timestamp_shim(nsecs_t timestamp,
                                int32_t msgType,
                                const sp<IMemory> &dataPtr,
                                void *user)
    {
        struct camera_memory memory;
        memory.data = dataPtr->pointer();
        memory.size = dataPtr->size();
        memory.handle = NULL;
        memory.release = camera_release_memory_shim;
        shim_camera_device_t* shim_device = (shim_camera_device_t*)user;
        shim_device->data_cb_timestamp(timestamp, msgType, &memory, 0, shim_device->user);        
    }


    void camera_set_callbacks(struct camera_device * device,
            camera_notify_callback notify_cb,
            camera_data_callback data_cb,
            camera_data_timestamp_callback data_cb_timestamp,
            camera_request_memory get_memory,
            void *user)
    {
        LOGE("%x", device);
        shim_camera_device_t* shim_device = (shim_camera_device_t*)device;
        shim_device->user = user;
        sp<CameraHardwareInterface> hardware = shim_device->hardware;
        LOGE("setting callbacks");
        hardware->setCallbacks(notify_cb, data_callback_shim, data_callback_timestamp_shim, shim_device);
    }

    void camera_enable_msg_type(struct camera_device * device, int32_t msg_type)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        hardware->enableMsgType(msg_type);
    }

    void camera_disable_msg_type(struct camera_device * device, int32_t msg_type)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        hardware->disableMsgType(msg_type);
    }

    int camera_msg_type_enabled(struct camera_device * device, int32_t msg_type)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->msgTypeEnabled(msg_type);
    }

    int camera_start_preview(struct camera_device * device)
    {
        ((shim_camera_device_t*)device)->preview_enabled = 1;
        return 0;
    }

    void camera_stop_preview(struct camera_device * device)
    {
        ((shim_camera_device_t*)device)->preview_enabled = 0;
    }

    int camera_preview_enabled(struct camera_device * device)
    {
        return ((shim_camera_device_t*)device)->preview_enabled;
    }

    int camera_store_meta_data_in_buffers(struct camera_device * device, int enable)
    {
        return 0;
    }

    int camera_start_recording(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->startRecording();
    }

    void camera_stop_recording(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        hardware->stopRecording();
    }

    int camera_recording_enabled(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->recordingEnabled();
    }

    void camera_release_recording_frame(struct camera_device * device,
                    const void *opaque)
    {
    }

    int camera_auto_focus(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->autoFocus();
    }

    int camera_cancel_auto_focus(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->cancelAutoFocus();
    }

    int camera_take_picture(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->takePicture();
    }

    int camera_cancel_picture(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->cancelPicture();
    }

    int camera_set_parameters(struct camera_device * device, const char *params)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->setParameters(CameraParameters(String8(params)));
    }

    char* camera_get_parameters(struct camera_device * device)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return (char*)hardware->getParameters().flatten().string();
    }

    static void camera_put_parameters(struct camera_device *device, char *parms)
    {
    }

    int camera_send_command(struct camera_device * device,
                int32_t cmd, int32_t arg1, int32_t arg2)
    {
        sp<CameraHardwareInterface> hardware = ((shim_camera_device_t*)device)->hardware;
        return hardware->sendCommand(cmd, arg1, arg2);
    }

    void camera_release(struct camera_device * device)
    {
    }

    int camera_dump(struct camera_device * device, int fd)
    {
        return 0;
    }

    int camera_device_close(hw_device_t* device)
    {
        return 0;
    }

Overlay::Overlay(const sp<OverlayRef>& overlayRef)
    : mOverlayRef(overlayRef), mOverlayData(0), mStatus(NO_INIT)
{
    mOverlayData = NULL;
    hw_module_t const* module;
    if (overlayRef != 0) {
        if (hw_get_module(OVERLAY_HARDWARE_MODULE_ID, &module) == 0) {
            if (overlay_data_open(module, &mOverlayData) == NO_ERROR) {
                mStatus = mOverlayData->initialize(mOverlayData,
                        overlayRef->mOverlayHandle);
            }
        }
    }
}

Overlay::~Overlay() {
    if (mOverlayData) {
        overlay_data_close(mOverlayData);
    }
}

status_t Overlay::dequeueBuffer(overlay_buffer_t* buffer)
{
    if (mStatus != NO_ERROR) return mStatus;
    return  mOverlayData->dequeueBuffer(mOverlayData, buffer);
}

status_t Overlay::queueBuffer(overlay_buffer_t buffer)
{
    if (mStatus != NO_ERROR) return mStatus;
    return mOverlayData->queueBuffer(mOverlayData, buffer);
}

int32_t Overlay::getBufferCount() const
{
    if (mStatus != NO_ERROR) return mStatus;
    return mOverlayData->getBufferCount(mOverlayData);
}

void* Overlay::getBufferAddress(overlay_buffer_t buffer)
{
    if (mStatus != NO_ERROR) return NULL;
    return mOverlayData->getBufferAddress(mOverlayData, buffer);
}

void Overlay::destroy() {  
    if (mStatus != NO_ERROR) return;
    mOverlayRef->mOverlayChannel->destroy();
}

status_t Overlay::getStatus() const {
    return mStatus;
}

overlay_handle_t Overlay::getHandleRef() const {
    if (mStatus != NO_ERROR) return NULL;
    return mOverlayRef->mOverlayHandle;
}

uint32_t Overlay::getWidth() const {
    if (mStatus != NO_ERROR) return 0;
    return mOverlayRef->mWidth;
}

uint32_t Overlay::getHeight() const {
    if (mStatus != NO_ERROR) return 0;
    return mOverlayRef->mHeight;
}

int32_t Overlay::getFormat() const {
    if (mStatus != NO_ERROR) return -1;
    return mOverlayRef->mFormat;
}

int32_t Overlay::getWidthStride() const {
    if (mStatus != NO_ERROR) return 0;
    return mOverlayRef->mWidthStride;
}

int32_t Overlay::getHeightStride() const {
    if (mStatus != NO_ERROR) return 0;
    return mOverlayRef->mHeightStride;
}
// ----------------------------------------------------------------------------

OverlayRef::OverlayRef() 
 : mOverlayHandle(0),
    mWidth(0), mHeight(0), mFormat(0), mWidthStride(0), mHeightStride(0),
    mOwnHandle(true)
{    
}

OverlayRef::OverlayRef(overlay_handle_t handle, const sp<IOverlay>& channel,
         uint32_t w, uint32_t h, int32_t f, uint32_t ws, uint32_t hs)
    : mOverlayHandle(handle), mOverlayChannel(channel),
    mWidth(w), mHeight(h), mFormat(f), mWidthStride(ws), mHeightStride(hs),
    mOwnHandle(false)
{
}

OverlayRef::~OverlayRef()
{
    if (mOwnHandle) {
        native_handle_close(mOverlayHandle);
        native_handle_delete(const_cast<native_handle*>(mOverlayHandle));
    }
}

sp<OverlayRef> OverlayRef::readFromParcel(const Parcel& data) {
    sp<OverlayRef> result;
    sp<IOverlay> overlay = IOverlay::asInterface(data.readStrongBinder());
    if (overlay != NULL) {
        uint32_t w = data.readInt32();
        uint32_t h = data.readInt32();
        uint32_t f = data.readInt32();
        uint32_t ws = data.readInt32();
        uint32_t hs = data.readInt32();
        native_handle* handle = data.readNativeHandle();

        result = new OverlayRef();
        result->mOverlayHandle = handle;
        result->mOverlayChannel = overlay;
        result->mWidth = w;
        result->mHeight = h;
        result->mFormat = f;
        result->mWidthStride = ws;
        result->mHeightStride = hs;
    }
    return result;
}

status_t OverlayRef::writeToParcel(Parcel* reply, const sp<OverlayRef>& o) {
    if (o != NULL) {
        reply->writeStrongBinder(o->mOverlayChannel->asBinder());
        reply->writeInt32(o->mWidth);
        reply->writeInt32(o->mHeight);
        reply->writeInt32(o->mFormat);
        reply->writeInt32(o->mWidthStride);
        reply->writeInt32(o->mHeightStride);
        reply->writeNativeHandle(o->mOverlayHandle);
    } else {
        reply->writeStrongBinder(NULL);
    }
    return NO_ERROR;
}


enum {
    DESTROY = IBinder::FIRST_CALL_TRANSACTION, // one-way transaction
};

class BpOverlay : public BpInterface<IOverlay>
{
public:
    BpOverlay(const sp<IBinder>& impl)
        : BpInterface<IOverlay>(impl)
    {
    }

    virtual void destroy()
    {
        Parcel data, reply;
        data.writeInterfaceToken(IOverlay::getInterfaceDescriptor());
        remote()->transact(DESTROY, data, &reply, IBinder::FLAG_ONEWAY);
    }
};

IMPLEMENT_META_INTERFACE(Overlay, "android.ui.IOverlay");

// ----------------------------------------------------------------------

#define CHECK_INTERFACE(interface, data, reply) \
        do { if (!data.enforceInterface(interface::getInterfaceDescriptor())) { \
            LOGW("Call incorrectly routed to " #interface); \
            return PERMISSION_DENIED; \
        } } while (0)

status_t BnOverlay::onTransact(
    uint32_t code, const Parcel& data, Parcel* reply, uint32_t flags)
{
    switch(code) {
        case DESTROY: {
            CHECK_INTERFACE(IOverlay, data, reply);
            destroy();
            return NO_ERROR;
        } break;
        default:
            return BBinder::onTransact(code, data, reply, flags);
    }
}


// ----------------------------------------------------------------------------



  extern "C" int HAL_openCameraHardwareShim(const struct hw_module_t* module, const char* name, struct hw_device_t** device) {
          int rv = 0;
          int num_cameras = 0;
          int cameraid;
          shim_camera_device_t* camera_device = NULL;
          camera_device_ops_t* camera_ops = NULL;

          android::Mutex::Autolock lock(gCameraHalDeviceLock);

          LOGI("camera_device open");

          if (name != NULL) {
              cameraid = atoi(name);
              num_cameras = HAL_getNumberOfCameras();

              if(cameraid > num_cameras)
              {
                  LOGE("camera service provided cameraid out of bounds, "
                          "cameraid = %d, num supported = %d",
                          cameraid, num_cameras);
                  rv = -EINVAL;
                  goto fail;
              }

              camera_device = (shim_camera_device_t*)malloc(sizeof(*camera_device));
              if(!camera_device)
              {
                  LOGE("camera_device allocation fail");
                  rv = -ENOMEM;
                  goto fail;
              }
              LOGE("camera device: %x", camera_device);

              camera_ops = (camera_device_ops_t*)malloc(sizeof(*camera_ops));
              if(!camera_ops)
              {
                  LOGE("camera_ops allocation fail");
                  rv = -ENOMEM;
                  goto fail;
              }

              memset(camera_device, 0, sizeof(*camera_device));
              memset(camera_ops, 0, sizeof(*camera_ops));

              sp<CameraHardwareInterface> hardware = HAL_openCameraHardware(cameraid);
              if (hardware == NULL) {
                  LOGE("Fail to open camera hardware (id=%d)", cameraid);
                  rv = -EINVAL;
                  goto fail;
              }
              
              camera_device->hardware = hardware;
              camera_device->preview_enabled = 0;

              camera_device->base.common.tag = HARDWARE_DEVICE_TAG;
              camera_device->base.common.version = 0;
              camera_device->base.common.module = (hw_module_t *)(module);
              camera_device->base.common.close = camera_device_close;
              camera_device->base.ops = camera_ops;

              camera_ops->set_preview_window = camera_set_preview_window;
              camera_ops->set_callbacks = camera_set_callbacks;
              camera_ops->enable_msg_type = camera_enable_msg_type;
              camera_ops->disable_msg_type = camera_disable_msg_type;
              camera_ops->msg_type_enabled = camera_msg_type_enabled;
              camera_ops->start_preview = camera_start_preview;
              camera_ops->stop_preview = camera_stop_preview;
              camera_ops->preview_enabled = camera_preview_enabled;
              camera_ops->store_meta_data_in_buffers = camera_store_meta_data_in_buffers;
              camera_ops->start_recording = camera_start_recording;
              camera_ops->stop_recording = camera_stop_recording;
              camera_ops->recording_enabled = camera_recording_enabled;
              camera_ops->release_recording_frame = camera_release_recording_frame;
              camera_ops->auto_focus = camera_auto_focus;
              camera_ops->cancel_auto_focus = camera_cancel_auto_focus;
              camera_ops->take_picture = camera_take_picture;
              camera_ops->cancel_picture = camera_cancel_picture;
              camera_ops->set_parameters = camera_set_parameters;
              camera_ops->get_parameters = camera_get_parameters;
              camera_ops->put_parameters = camera_put_parameters;
              camera_ops->send_command = camera_send_command;
              camera_ops->release = camera_release;
              camera_ops->dump = camera_dump;

              *device = &camera_device->base.common;
          }

          return rv;

      fail:
          if(camera_device) {
              free(camera_device);
              camera_device = NULL;
          }
          if(camera_ops) {
              free(camera_ops);
              camera_ops = NULL;
          }
          // if(camera) {
          //     delete camera;
          //     camera = NULL;
          // }
          *device = NULL;
          return rv;
  }
  
}
