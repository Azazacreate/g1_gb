
/* Change C compiler optimization options, before nondeterm C kode */

#if defined(WIN32)
#pragma optimize("",off)
#elif defined(__TURBOC__) && defined(__OS2__)
#pragma option -Od -Oa -Ob -Oc
#elif defined(__TURBOC__)
#pragma option -Od -r-
#elif defined(__IBMC__)
// Not possible
#endif
