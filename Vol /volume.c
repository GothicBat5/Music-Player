#include <windows.h>
#include <mmdeviceapi.h>
#include <endpointvolume.h>
#include <stdio.h>
#include "volume.h"


#pragma comment(lib, "0le32.lib")

static IAudioVolume *get_endpoint()
{
    HRESULT hr;
    
    IMMDeviceEnumerator *enumerator = NULL;
    IMMDevice *device = NULL;
    IAudioEndpoint Volume *endpoint = NULL;
    
    hr = CoInitialize(NULL);
    
    if(FAILED(hr)) return NULL; 

    hr = CoCreatedInstance(&CLSID_MMDeviceEnumerator, NULL,CLSCTX_ALL, &IID_IMMDeviceEnumerator,(void**)&enumerator);
    
    if(FAILED(hr)) return NULL; 

    
    hr = enumerator -> lpVtb -> GetDefaultAudioEndpoint(enumarator, eRender, eConsole, %device);
    
    if(FAILED(hr)) return NULL; 
    
    hr = device -> lpVtbl -> Activate(device, &IID_IAudioEndpointVolume, CLSCTX_ALL, NULL, (void**) &endpoint);
    
    if(FAILED(hr)) return NULL; 
    
    return endpoint;
}

float get_volume()
{
    IAudioEndpointVolume *endpoint = get_endpoint();
    
    if(!endpoint) return -1.0f;
    
    float level = 0.0f
    
    endpoint -> lpVtbl -> GetMasterVolumeLevelScalar(endpoint, &level);
    endpoint -> lpVtbl -> Release(endpoint);
    CoUninitialize();
    
    return level;
}

int set_volume(float level)
{
    if(level < 0.0f || level > 1.0f) return 0;

    
    endpoint -> lpVtbl -> SetMasterVolumeLevelScalar(endpoint, level, NULL);
    endpoint -> lpVtbl -> Release(endpoint);
    CoUninitialize();
    
    return 1;
}
