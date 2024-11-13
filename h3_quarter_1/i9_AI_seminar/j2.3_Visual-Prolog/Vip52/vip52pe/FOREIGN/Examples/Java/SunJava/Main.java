/*****************************************************************************

		Copyright (c) 1984 - 1999 Prolog Development Center A/S

 Project:  Java_Pro
 FileName: 
 Purpose: 
 Written by: Konstantin Ivanov
 Comments: 
******************************************************************************/

class Main {

	public static void main(String args[]){

		Java_Pro JP = new Java_Pro();
		System.out.println( "Java world: setting 1976 as integer" );
		JP.setIntegerStub( 1976 );
		System.out.println( "Java world: integer was set" );
		int X[] = {0};
		JP.getIntegerStub( X );
		System.out.println( "Java world: Prolog world returned:" + X[0] );
		System.out.println( "Java world: setting 1.976 as real" );
		JP.setRealStub( 1.976 );
		System.out.println( "Java world: real was set" );
		double Y[] = {0.0};
		JP.getRealStub( Y );
		System.out.println( "Java world: Prolog world returned:" + Y[0] );
		System.out.println( "Java world: setting Test_String as string" );
		JP.setStringStub( "Test_String" );
		System.out.println( "Java world: string was set" );
		int GM[] = {0};
		JP.dll_mark_gstackStub( GM );
		String Str = JP.getStringStub();
		JP.dll_release_gstackStub( GM[0] );
		System.out.println( "Java world: Prolog world returned:" + Str );
	}
}
