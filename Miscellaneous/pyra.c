#include <stdio.h>

int main()
{
    int level;
    
    printf("Number layers: ");
    scanf("%d", &level);
    
    for(int i = 1; i <= level; i++)
    {
        for(int j = 1; j <= level - i; j++)
        {
            printf(" ");
        }
        
        for(int k = 1; k <= 2 * i - 1; k++)
        {
            printf("*");
        }
        printf("\n"); 
    }
    printf("\nMerry Christmas!"); 
    return 0; 
}
