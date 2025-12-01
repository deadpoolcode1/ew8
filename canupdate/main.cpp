#include <stdio.h>
#include "mainprocessapi.h"

int main(int argc, char *argv[])
{
    MainProcess* mp = new MainProcess();

    mp->LaunchEverything(argc, argv);

    return 0;
}
