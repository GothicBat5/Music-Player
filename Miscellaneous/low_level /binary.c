#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include <time.h>

int read_num()
{
    char input[100];
    char *end;
    long value;
    
    while(1)
    {
        printf("<Lines> : ");
        
        if(!fgets(input, sizeof(input), stdin)) continue;

        
        value = strtol(input, &end, 10);
        
        if(end == input || *end != '\n') printf("Invalid Input.");

        
        else if(value < 0) printf("Not valid input");

        else return (int) value;
    }
}

int main()
{
    int n = read_num();
    
    srand(time(NULL));
    
    clock_t start = clock();
    
    char buffer[10];
    
    for(int i = 1; i < n; i++)
    {
        
        for(int j = 0; j < 9; j++)
        {
            
            buffer[j] = (rand() % 2 )? '1' : '0';
        }
        
        buffer[9] = '\0';
        
        printf("[ %d. ] = %s\n", i, buffer);
    }
    
    double elapsed = (double) (clock() - start) / CLOCKS_PER_SEC;
    printf("\n\nTime elapsed: %f seconds\n", elapsed);
    
    return 0; 
}

