/* Generated by Nimrod Compiler v0.9.4 */
/*   (c) 2014 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Windows, amd64, gcc */
/* Command for C compiler:
   "C:\Program Files (x86)\Nimrod\dist\mingw\bin\gcc.exe" -c  -w  -I"C:\Program Files (x86)\Nimrod\lib" -o c:\users\brnedan\documents\github\nimrod-bigint\nimcache\strutils.o c:\users\brnedan\documents\github\nimrod-bigint\nimcache\strutils.c */
#define NIM_INTBITS 64
#include "nimbase.h"
static N_INLINE(void, nimFrame)(TFrame* s);
static N_INLINE(void, popFrame)(void);
extern TFrame* frameptr_13038;

static N_INLINE(void, nimFrame)(TFrame* s) {
	(*s).prev = frameptr_13038;
	frameptr_13038 = s;
}

static N_INLINE(void, popFrame)(void) {
	frameptr_13038 = (*frameptr_13038).prev;
}
N_NOINLINE(void, strutilsInit)(void) {
	nimfr("strutils", "strutils.nim")
	popFrame();
}

N_NOINLINE(void, strutilsDatInit)(void) {
}
