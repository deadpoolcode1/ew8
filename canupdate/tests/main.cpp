#include <stdio.h>
#include "mainprocessload.h"

int main(int argc, char *argv[])
{
    MainProcess* mp = new MainProcess();

    printf("Starting can_load\n");

    mp->LaunchEverything(argc, argv);

    return 0;
}
