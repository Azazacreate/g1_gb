
/* Restore C compiler optimization options, after nondeterm C kode */

#if defined(WIN32)
#pragma optimize("",on)
#elif defined(__TURBOC__) && defined(__OS2__)
#pragma option -Oi -Oz -Ob -Oe -Oc -O -Ot
#elif defined(__TURBOC__)
#pragma option -r+ -Ot
#elif defined(__IBMC__)
// Not possible
#endif
