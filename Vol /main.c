#include <stdio.h>
#include "volume.h"

int main()
{
    float curr = get_volume();

    if(curr < 0)
    {
        printf("Failed to recognize current volume.\n");
        return 1;
    }

    printf("Current volume: %.2f\n", curr);

    float newVol;

    printf("Enter new volume: ");

    if(scanf("%f", &newVol) != 1)
    {
        printf("Invalid input.\n");
        return 1;
    }

    if(newVol < 0)
    {
        printf("Volume cannot be negative.\n");
        return 1;
    }

    if(!set_volume(newVol))
    {
        printf("Failed to set volume.\n");
        return 1;
    }

    printf("Volume changed successfully.\n");

    return 0;
}
