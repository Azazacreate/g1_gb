#include <jni.h>
#include "Java_ProJNI.h"

void __stdcall setInteger( int );
void __stdcall getInteger( int* );
void __stdcall setReal( double );
void __stdcall getReal( double* );
void __stdcall dll_release_gstack( int );
void __stdcall dll_mark_gstack( int* );
void __stdcall setString( const char* );
void __stdcall getString( char** );

JNIEXPORT void JNICALL Java_Java_1Pro_getIntegerStub(JNIEnv *env, jobject self, jintArray nArr ){
	int nValue[] = {0};
	getInteger( nValue );
	(*env) -> SetIntArrayRegion( env, nArr, 0, 1, nValue );
}
JNIEXPORT void JNICALL Java_Java_1Pro_setIntegerStub(JNIEnv *env, jobject self, jint nNumber ){
	setInteger( nNumber );
}
JNIEXPORT void JNICALL Java_Java_1Pro_getRealStub(JNIEnv *env, jobject self, jdoubleArray fArr ){
	double fValue[] = {0.0};
	getReal( fValue );
	(*env) -> SetDoubleArrayRegion( env, fArr, 0, 1, fValue );
}
JNIEXPORT void JNICALL Java_Java_1Pro_setRealStub(JNIEnv *env, jobject self, jdouble fNumber ){
	setReal( fNumber );
}
JNIEXPORT void JNICALL Java_Java_1Pro_dll_1mark_1gstackStub( JNIEnv *env, jobject self, jintArray nArr){
	int nValue[] = {0};
	dll_mark_gstack( nValue );
	(*env) -> SetIntArrayRegion( env, nArr, 0, 1, nValue );
}
JNIEXPORT void JNICALL Java_Java_1Pro_dll_1release_1gstackStub(JNIEnv *env, jobject self, jint nGM ){
	dll_release_gstack( nGM );
}
JNIEXPORT jstring JNICALL Java_Java_1Pro_getStringStub(JNIEnv *env, jobject self){
	char *Out;
	getString( &Out );
	return (*env) -> NewStringUTF( env, (const char*) Out );
}
JNIEXPORT void JNICALL Java_Java_1Pro_setStringStub(JNIEnv *env, jobject self, jstring txt){
	const char *ctxt = (*env) -> GetStringUTFChars( env, txt, 0 );
	if (ctxt == NULL){
		return; // out of memory
	}
	setString( ctxt );
	(*env) -> ReleaseStringUTFChars( env, txt, ctxt );
}