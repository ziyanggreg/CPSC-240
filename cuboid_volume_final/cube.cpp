//CONTACT INFO:
//AUTHOR: Greg Zhang
//Email: ziyangz@csu.fullerton.edu

#include <cstdio>
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <iostream>

extern "C" double cube_volume();

int main()
{
    printf("Welcome to cuboids programmed by Greg Zhang\n");
    double volume;
    volume = cube_volume();
    printf("\nFunction main received this number %.2lf and will view it.\n", volume);
    printf("We strive to please the customer. Enjoy your cuboids.\n");
    return 0;
}
