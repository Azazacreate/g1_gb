/*****************************************************************************

		Copyright (c) 1984 - 1999 Prolog Development Center A/S

 Project:  Java_Pro
 FileName: 
 Purpose: 
 Written by: Konstantin Ivanov
 Comments: 
******************************************************************************/

class Java_Pro {

	public native void dll_mark_gstackStub( int pSomeGMark[] );
	public native void dll_release_gstackStub( int SomeGMark );
	public native void setIntegerStub( int SomeNumber );
	public native void getIntegerStub( int pSomeNumber[] );
	public native void setRealStub( double SomeNumber );
	public native void getRealStub( double pSomeNumber[] );
	public native void setStringStub( String SomeStr );
	public native String getStringStub();
	static {
             System.loadLibrary("Stub");
	}
}
