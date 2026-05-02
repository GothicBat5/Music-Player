#include <stdio.h>
#include "volume.h"

int main()
{
    float curr = get_volume; 
    
    if(curr < 0)
    {
        printf("Failed to recognized");
        return 1;
    }
    
    printf("Current: %.2f \n", curr);
    
    float newVol;
    
    if(scanf("%f", &newVol) != 1)
    {
        printf("Invalid");
        return 1;
    }
    
    if(!set_volume(newVol))
    {
        printf("Failed");
        return 1;
    }
    return 0; 
}
