/* Copyright (c) 1984 - 2000 Prolog Development Center A/S */
char prowin_msg(char *);

void hello_c()
{
  while ( prowin_msg("Hello from C (press 'C')") != 'C' )
    ;
}
