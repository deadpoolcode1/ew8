#include "utils.h"

char ascii2hex(char a)
{
   if ((a>='0') && (a<='9')) return (int)(a-'0');
   if ((a>='A') && (a<='F')) return (10+(int)(a-'A'));
   if ((a>='a') && (a<='f')) return (10+(int)(a-'a'));
   return 0;
}

void str2hash(const char* _str, char* _buffer)
{
   const int HashBytes = 32;

    for (int i = 0; i < HashBytes; i++)
    {
        char bt = (ascii2hex(_str[2*i]) << 4) | (ascii2hex(_str[2*i+1]));
        _buffer[i] = bt;
    }
}
