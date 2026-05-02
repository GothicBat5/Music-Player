#include <stdio.h>
#include <alsa/asoundlib.h>
#include "volume.v"

int main(int argc, char *argv[]) 
{

    long min, max;
    long volume;

    if (argc < 2) 
    {
        fprintf(stderr, "Usage: %s <volume_percent>\n", argv[0]);
        return 1;
    }

    int target = atoi(argv[1]); 

    snd_mixer_t *handle;
    snd_mixer_selem_id_t *sid;
    snd_mixer_elem_t* elem;

    snd_mixer_open(&handle, 0);
    snd_mixer_attach(handle, "default");
    snd_mixer_selem_register(handle, NULL, NULL);
    snd_mixer_load(handle);

    //identify the master control
    snd_mixer_selem_id_malloc(&sid);
    snd_mixer_selem_id_set_index(sid, 0);
    snd_mixer_selem_id_set_name(sid, "Master");
    elem = snd_mixer_find_selem(handle, sid);

    snd_mixer_selem_get_playback_volume_range(elem, &min, &max);

    //ercentage to hardware range
    volume = (target * (max - min) / 100) + min;

    //s volume
    snd_mixer_selem_set_playback_volume_all(elem, volume);

    //cleanup
    snd_mixer_close(handle);
    snd_mixer_selem_id_free(sid);

    printf("Volume set to %d%%\n", target);
    return 0;
}
