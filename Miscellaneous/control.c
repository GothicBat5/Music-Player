#include <stdio.h>

int main()
{
    int rows, columns;
    char sym;

    printf("Rows: ");
    scanf_s("%d", &rows);

    printf("Columns: ");
    scanf_s("%d", &columns);

    printf("Symbol: ");
    scanf_s(" %c", &sym);

    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < columns; j++)
        {
            printf("%c", sym);
        }
        printf("\n");
    }
    return 0;
}
