#include <stdio.h>
#include "mainprocessupdate.h"

int main(int argc, char *argv[])
{
    MainProcess* mp = new MainProcess();

    mp->LaunchEverything(argc, argv);

    return 0;
}
