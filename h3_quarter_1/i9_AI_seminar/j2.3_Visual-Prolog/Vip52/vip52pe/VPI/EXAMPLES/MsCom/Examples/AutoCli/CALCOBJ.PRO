/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CALCCLI
 FileName: CALCOBJ.PRO
 Purpose: No description
 Written by: 
 Comments:
******************************************************************************/

include "calccli.inc"

CONSTANTS
  %% Program Identifier of the object we'll work with
  progId = "Mycalc3.Application"

database - calc_dispatch
  determ ole_init_flag
  determ calc_disp(vpcD_IPOINTER)


predicates
  
  create_calculator_object1()  
  calc_Quit(vpcD_IPOINTER)
  operator_str(integer,string)
  
  
CLAUSES

  /******************************************************************************************
  
      Retrieving Calculator Properies : "Accum", "Op" and "Opnd"
  
  ******************************************************************************************/
  
  calc_get_Accumulator( Accum ) :-
  	calc_disp(IP),
  	MethodName = "Accumulator" ,
	Arguments = [],
  	comutilP_DispInvoke(IP, vpcD_disp_property_get, MethodName, Arguments, Result ),
  	Result = vpcD_VT_I4(LAccum),
  	str_int(Accum,LAccum),!.
  calc_get_Accumulator( "Unknown" ).
  	
  calc_get_Operator( Operator ) :-
  	calc_disp(IP),
  	MethodName = "Operator" ,
	Arguments = [],
  	comutilP_DispInvoke(IP, vpcD_disp_property_get, MethodName, Arguments, Result ),
  	Result = vpcD_VT_I4(LOp),
  	operator_str(LOp,Operator).
  	
  calc_get_Opnd( Opnd ) :-
  	calc_disp(IP),
  	MethodName = "Operand" ,
	Arguments = [],
  	comutilP_DispInvoke(IP, vpcD_disp_property_get, MethodName, Arguments, Result ),
  	Result = vpcD_VT_I4(LOpnd),
  	str_int(Opnd,LOpnd),!.
  calc_get_Opnd( "Unknown" ).

  calc_get_Displ( Displ ) :-
  	calc_disp(IP),
  	MethodName = "Display" ,
	Arguments = [],
  	comutilP_DispInvoke(IP, vpcD_disp_property_get, MethodName, Arguments, Result ),
  	Result = vpcD_VT_I4(LOpnd),
  	str_int(Displ,LOpnd),!.
  calc_get_Displ( "Unknown" ).


  /****************************************************************************************
  
       Calling "Button" method
  
  ****************************************************************************************/

  calc_Push(Button) :-
  	calc_disp(IP),
  	MethodName = "Button" ,
  	Arguments = [vpcD_VT_BSTR(Button)],
  	comutilP_DispInvoke(IP, vpcD_disp_method, MethodName, Arguments, _Result ).


  /****************************************************************************************
  
       Calling "Quit" method
  
  ****************************************************************************************/

  calc_Quit(IP) :-
  	MethodName = "Quit" ,
  	Arguments = [],
  	comutilP_DispInvoke(IP, vpcD_disp_method, MethodName, Arguments, _Result ).


  /***************************************************************************************
  
       Initializing OLE system and the object we need.
  
  ***************************************************************************************/

  create_calculator_object() :-
  	b_true = comutilP_OleInitialize(),!,
  		assert(ole_init_flag),
  		create_calculator_object1().
  create_calculator_object().
    
  create_calculator_object1() :-
  	s_ok = comutilP_CreateAutomationObject(progId,IP),!,
  		assert(calc_disp(IP)).
  create_calculator_object1().


  /***************************************************************************************
  
       Releasing the object and OLE system.
  
  ***************************************************************************************/
  	
  release_calculator_object() :-
  	retract(calc_disp(IP)),!,
  	   calc_Quit(IP),
  	   comutilP_Release(IP),
  	   retract(ole_init_flag),
  	   comutilP_OleUnInitialize(),!.
  release_calculator_object():-
  	retract(ole_init_flag),!,
  		comutilP_OleUnInitialize().
  release_calculator_object().
  

  /*************************************************************************************
  
       Checking the object initialization.
  
  *************************************************************************************/  	
  
  check_calculator_object() :-
  	calc_disp(_),!.
  check_calculator_object() :-
  	ole_init_flag,!,
  	  dlg_note("Can't initialize MyCalc3 Application"),
  	  fail.
  check_calculator_object() :-
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
