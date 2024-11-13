/* Copyright (c) 1984 - 2000 Prolog Development Center A/S */
#define	listfno  1
#define	nilfno   2
typedef unsigned char BYTE;

void *MEM_AllocGStack(unsigned);


typedef struct ilist {
  BYTE Functor;
  int Value;
  struct ilist *Next;
} INTLIST;


int ListToArray(INTLIST *List,int **ResultArray)
{
  INTLIST *SaveList = List;
  int *Array, len;
  register int *ArrP;
  register int i;

  /* Count the number of elements in the list */
  i = 0;
  while ( List->Functor == listfno ) {
    i++;
    List = List->Next;
  }
  len = i;

  Array = MEM_AllocGStack(i*sizeof(int));
  ArrP = Array;

  /* Transfer the elements from the list to the array */
  List = SaveList;
  while ( i != 0 ) {
    *ArrP++ = List->Value;
    List = List->Next;
    i--;
  }

  *ResultArray = Array;
  return(len);
}


void ArrayToList(register int *ArrP,register int n,register INTLIST **ListPP)
{
  while ( n != 0 ) {
    *ListPP = MEM_AllocGStack(sizeof(INTLIST));
    (*ListPP)->Functor = listfno;
    (*ListPP)->Value = *ArrP++;
    ListPP = &(*ListPP)->Next;
    n--;
  }
  *ListPP = MEM_AllocGStack(sizeof((*ListPP)->Functor));/* End of list */
  (*ListPP)->Functor = nilfno;
}


void inclist(INTLIST *InList,INTLIST **OutList)
{
  register int *ArrP, i, len;
  int *Array;

  len = ListToArray(InList,&Array);
  ArrP = Array;
  for ( i = 0; i < len; i++)
    ++*ArrP++;
  ArrayToList(Array,len,OutList);
}
