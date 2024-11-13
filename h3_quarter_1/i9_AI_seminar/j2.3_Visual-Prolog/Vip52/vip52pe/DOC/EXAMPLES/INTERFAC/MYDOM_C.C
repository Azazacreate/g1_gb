/* Copyright (c) 1984 - 2000 Prolog Development Center A/S */
typedef struct {
  unsigned char func;
  union {
    int i;
    char c;
    char *s;
  } u;
} MYDOM;

void *MEM_AllocGStack(unsigned);
char *MEM_SaveStringGStack(char *);

void make_mydom(register MYDOM **md)
{
  *md = MEM_AllocGStack(sizeof(MYDOM));
  (*md)->func = 3;
  (*md)->u.s = MEM_SaveStringGStack("wombat");
}
