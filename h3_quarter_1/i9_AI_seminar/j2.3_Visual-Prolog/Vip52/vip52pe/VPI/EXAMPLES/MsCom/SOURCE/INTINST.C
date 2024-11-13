/*******************************************************************************

                                                INTINST.C

    Visual Prolog COM utility library module.


  Global Functions :
comutilP_CreateVPInterfaceInstance
comutilP_DeleteVPInterfaceInstance
comutilP_GetMethodPointer

    Written by Sergey Verkhovtsev


*******************************************************************************/


#include <windows.h>
#include <ole2.h>


/* Structure of PDC MethodList* list node */
typedef struct _MethodListPtrNode {
        unsigned char fno ;
        void*   method ;
        struct _MethodListPtrNode* next ;
} MethodListPtrNode ;


/* PDC list fno values */
#define NIL_FNO         2                               /* The last element (empty element) in the list */
#define NODE_FNO        1               /* The normal element of the list   */



/* The structure of any Interface ( Any InterfacePointer points to the pointer to array of methods )*/
typedef struct _InterfaceStruct {
        void* vtbl ;
} InterfaceStruct ;



/*==============================================================================

 Internal function
   int count_Method_nodes( MethodListPtrNode* head )


 Counts the number of elements in the given list of Method Pointers

==============================================================================*/
static int count_Method_nodes( MethodListPtrNode* head )
{
        int cnt = 0 ;
        MethodListPtrNode* h = head ;


        while( h->fno != NIL_FNO ) {
                ++cnt ;
                h = h->next ;
        }

        return cnt ;
}


/*=============================================================================
  Finction      comutilP_CreateVPInterfaceInstance

  Creates instance of the correct interface struct from the list of
methods pointers.

  Returns interface pointer.

=============================================================================*/

void* comutilP_CreateVPInterfaceInstance( MethodListPtrNode* methods )
{
        InterfaceStruct* intrs ;
        int cnt = count_Method_nodes( methods ) ;

        if( !cnt ) return NULL ;
        else {
                intrs = (InterfaceStruct*)CoTaskMemAlloc(sizeof(InterfaceStruct)) ;
                if( intrs != NULL ) {
                        void** mvtbl = (void**)CoTaskMemAlloc(sizeof(void*)*cnt) ;
                        intrs->vtbl = mvtbl ;
                        if( intrs->vtbl != NULL ) {
                                int i ;
                                for(i=0;i<cnt;i++) {
                                        mvtbl[i] = methods->method ;
                                        methods = methods->next ;
                                }
                        }
                        else {
                                CoTaskMemFree(intrs) ;
                                intrs = NULL ;
                        }
                }
        }

        return intrs ;
}



/*=============================================================================
  Finction      comutilP_DeleteVPInterfaceInstance

  Deletes instance of the interface struct created by
comutilP_CreateVPInterfaceInstance

=============================================================================*/
void comutilP_DeleteVPInterfaceInstance( InterfaceStruct* intrs )
{
        CoTaskMemFree(intrs->vtbl) ;
        CoTaskMemFree(intrs) ;
}



/*=============================================================================
  Finction      comutilP_GetMethodPointer

  Returns pointer to the method with given index of the given interface.

=============================================================================*/
void comutilP_GetMethodPointer( InterfaceStruct* intrs, int iMethodIndex, DWORD* pdwMethodPointer )
{
  DWORD* mvtbl = (DWORD*)(intrs->vtbl) ;
  *pdwMethodPointer = mvtbl[iMethodIndex] ;
}