/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CALCCLI
 FileName: CALCOBJ.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "calccli.inc"

CONSTANTS

clsid_MyCalc3  = guid(0xfb1ae905,0x4a0b,0x11d1,0xb1,0xf7,0,0xaa,0,0x19,0xf5,0xfb)
iid_ICalculator = guid(0xe92e6f10,0x4ab5,0x11d1,0xb1,0xf8,0,0xaa,0,0x19,0xf5,0xfb)

database - calc_binary
  determ ole_init_flagB
  determ iun_get_flag
  determ cr_inst(vpcD_RESULT)
  determ calc_interface(vpcD_IPOINTER)
  determ calc_object(MSCalculator)

predicates  
  create_calculator_object1B()  
  calc_Quit(MSCalculator)
  operator_str(integer,string)  
 
CLAUSES

  /******************************************************************************************
  
      Retrieving Calculator Properies : "Accum", "Op" and "Opnd"
  
  ******************************************************************************************/
  
  calc_get_AccumulatorB( Accum ) :-
  	calc_object(Obj),
  	Obj:get_Accum(LAccum),
  	str_int(Accum,LAccum),!.
  calc_get_AccumulatorB( "Unknown" ).  	
  	
  calc_get_OperatorB( Operator ) :-
  	calc_object(Obj),
  	Obj:get_Op(LOp),
  	operator_str(LOp,Operator),!.
  calc_get_OperatorB( "NONE" ).
  
  calc_get_OpndB( Opnd ) :-
  	calc_object(Obj),
  	Obj:get_Opnd(LOpnd),
  	str_int(Opnd,LOpnd),!.
  calc_get_OpndB( "Unknown" ).

  calc_get_DisplB( Displ ) :-
  	calc_object(Obj),
  	Obj:get_Displ(LOpnd),
  	str_int(Displ,LOpnd),!.
  calc_get_DisplB( "Unknown" ).

  /****************************************************************************************
  
       Calling "Button" method
  
  ****************************************************************************************/

  calc_PushB(Button) :-
  	calc_object(Obj),
  	comutilP_StringToBSTR(Button,BButton),
	Obj:button(BButton),
	comutilP_FreeBSTR(BButton).


  /****************************************************************************************
  
       Calling "Quit" method
  
  ****************************************************************************************/

  calc_Quit(Obj) :-
  	Obj:quit().

  /***************************************************************************************
  
       Initializing OLE system and the object we need.
  
  ***************************************************************************************/

  create_calculator_objectB() :-
  	b_true = comutilP_OleInitialize(),!,
  		assert(ole_init_flagB),
  		create_calculator_object1B().
  create_calculator_objectB().
    
  create_calculator_object1B() :-
  	s_ok = comutilP_CreateInstance(clsid_MyCalc3,clsctx_local_server,iid_IUnknown,UIP),
  	assert(iun_get_flag),
 	RES = comutilP_QueryInterface(UIP,iid_ICalculator,IP ),
  	assert(cr_inst(RES)),
  	comutilP_Release(UIP),
  	s_ok = RES,!,
  		assert(calc_interface(IP)),
  		MSC = cast(MSCalculator,IP),
  		assert(calc_object(MSC)).
  create_calculator_object1B().


  /***************************************************************************************
  
       Releasing the object and OLE system.
  
  ***************************************************************************************/
  	
  release_calculator_objectB() :-
  	retract(calc_interface(IP)),!,
  	   retract(calc_object(Obj)),
  	   calc_Quit(Obj),
  	   comutilP_Release(IP),
  	   retract(ole_init_flagB),
  	   comutilP_OleUnInitialize(),!.
  release_calculator_objectB():-
  	retract(ole_init_flagB),!,
  		comutilP_OleUnInitialize().
  release_calculator_objectB().
  

  /*************************************************************************************
  
       Checking the object initialization.
  
  *************************************************************************************/  	
  
  check_calculator_objectB() :-
  	calc_interface(_),!.
  check_calculator_objectB() :-
        iun_get_flag,!,
        cr_inst(Code),
        IID = iid_Icalculator,
        IID = guid(L,W1,W2,_B1,_B2,_B3,_B4,_B5,_B6,_B7,_B8),
        format(S,"IUnknown OK, but no object. Code = %X\nIID = %X %X %X",Code,L,W1,W2),
        dlg_note(S),	
        fail.
  check_calculator_objectB() :-
  	ole_init_flagB,!,
  	  dlg_note("Can't initialize MyCALC3 Application ICalculator interface"),
  	  fail.
  check_calculator_objectB() :-
  	dlg_note("Can't initialize OLE system"),!,
  	fail.
  
  /***************************************************************************************
    
       Converting Operator code to string
       
  ***************************************************************************************/	  	
  operator_str(0,"NONE"):-!.
  operator_str(1,"PLUS"):-!.
  operator_str(2,"MINUS"):-!.
  operator_str(3,"MULT"):-!.
  operator_str(4,"DIV"):-!.
  operator_str(_,"UNKNOWN"):-!.
