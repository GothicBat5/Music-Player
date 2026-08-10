#include <stdio.h>
#include <math.h>
#include "miniaudio.h" // single header lib

float phase = 0.0f;

void data_callback(ma_device* pDevice, void* pOutput, const void* pInput, ma_uint32 frameCount) 
{
    float* output = (float*)pOutput;

    for(ma_uint32 i = 0; i < frameCount; i++) 
    {
        // GENERATE SOUND: 440Hz sine wave = A4 note
        float sample = sinf(phase) * 0.3f; // 0.3 = volume
        *output++ = sample; // left
        *output++ = sample; // right
        phase += 2.0f * 3.14159f * 440.0f / 44100.0f; // advance phase
    }
}

int main()
{
    ma_device_config config = ma_device_config_init(ma_device_type_playback);
    config.playback.format = ma_format_f32;
    config.playback.channels = 2;
    config.sampleRate = 44100;
    config.dataCallback = data_callback;

    ma_device device;
    ma_device_init(NULL, &config, &device);
    ma_device_start(&device);

    printf("Playing 440Hz... Press Enter to stop\n");
    getchar();

    ma_device_uninit(&device);
}
