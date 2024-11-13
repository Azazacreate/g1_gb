/*****************************************************************************

		Copyright (c) 1984 - 1999 Prolog Development Center A/S

 Project:  Java_Pro
 FileName: 
 Purpose: 
 Written by: Konstantin Ivanov
 Comments: 
******************************************************************************/

import com.ms.dll.*;

class Java_Pro {

	public static void main(String args[]){

		System.out.println( "Java world: setting 1976 as integer" );
		setInteger( 1976 );
		System.out.println( "Java world: integer was set" );
		int X[] = {0};
		getInteger( X );
		System.out.println( "Java world: Prolog world returned:" + X[0] );
		System.out.println( "Java world: setting 1.976 as real" );
		setReal( 1.976 );
		System.out.println( "Java world: real was set" );
		double Y[] = {0.0};
		getReal( Y );
		System.out.println( "Java world: Prolog world returned:" + Y[0] );
		System.out.println( "Java world: setting Test_String as string" );
		setString( "Test_String" );
		System.out.println( "Java world: string was set" );
		int pStrs[] = {0};
		int GM[] = {0};
		dll_mark_gstack( GM );
		getString( pStrs );
		String Str = DllLib.ptrToStringAnsi( pStrs[0] );
		dll_release_gstack( GM[0] );
		System.out.println( "Java world: Prolog world returned:" + Str );
		
	}
	/** @dll.import("Testdll") */
	private static native void dll_mark_gstack( int pSomeGMark[] );
	/** @dll.import("Testdll") */
	private static native void dll_release_gstack( int SomeGMark );
	/** @dll.import("Testdll") */
	private static native void setInteger( int SomeNumber );
	/** @dll.import("Testdll") */
	private static native void getInteger( int pSomeNumber[] );
	/** @dll.import("Testdll") */
	private static native void setReal( double SomeNumber );
	/** @dll.import("Testdll") */
	private static native void getReal( double pSomeNumber[] );
	/** @dll.import("Testdll") */
	private static native void setString( String SomeStr );
	/** @dll.import("Testdll") */
	private static native void getString( int pSomeStr[] );
}
