/**
 *  @brief include file defines encryption and decryption exported
 *          interfaces and supported function interfaces.
 *
 *  @file    stdafx.h
 */

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>
#include <ole2.h>
#include <stdio.h>
#include <cmath>
#include <string.h>

//supported interfaces for encryption and decryption
char *	encrypt_data	(char* pInput, char* pKey);
char *	StrToHexStr		(char* pEncStr, long pEncLen);

char *	decrypt_data	(char* pInput, char* pKey, long & pDecData);
char *	Hex2Char		(char* pDecStr, long pLen);
int		HexDm			(char* pValue);

// TODO: reference additional headers your program requires here
