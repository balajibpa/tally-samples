// CallCDllTest.cpp : Defines the exported functions for the DLL application.
//
/**
 *  @brief Defines the entry point for the DLL application.
 *
 *  @file    dllmain.cpp
 */

#include "stdafx.h"

/** 
 * @brief This function encrypts the data specified by the
 *        user and converts encrypted data to hex string.
 * 
 * @param pArgc [in]        number of input values
 * @param pArgv [in]		input values
 * @param pResult [out]     encrypted out buffer, this function allocates the buffer, user needs to release it
 * @param pResultSize [out] out buffer length
 * 
 */
extern "C" HRESULT __declspec (dllexport)
EncryptData (short pArgc, wchar_t ** pArgv, wchar_t ** pResult, long * pResultSize)
{	
		char *		data;
		char *		key;
		char *		encdata;
		long		datasz, keysz, encdatasz;
		
	//get data and key size
	datasz = wcslen (pArgv[0]) + 1;
	keysz = wcslen (pArgv[1]) + 1;

	//allocate memory
	data = (char*)calloc (datasz, sizeof (char));
	key = (char*)calloc (keysz, sizeof (char));

	//convert unicode to ansi
	WideCharToMultiByte (CP_ACP, 0, (LPCWSTR)pArgv[0], -1, data, datasz, NULL, NULL );
	WideCharToMultiByte (CP_ACP, 0, (LPCWSTR)pArgv[1], -1, key, keysz, NULL, NULL );

	//encrypt data
	encdata = encrypt_data (data, key);
	//get the encrypted data length
	encdatasz = strlen(encdata);

	//free the temp allocated buffers
	free (data);
	free (key);

	//copy the decrypted data and covert into unicode
	*pResultSize = encdatasz+1; //(encdatasz + 2) * sizeof (wchar_t);
	*pResult = static_cast<wchar_t *>(CoTaskMemAlloc (1024+1));
	memset (*pResult, 0, *pResultSize);

	MultiByteToWideChar (CP_ACP, 0, encdata, encdatasz, *pResult, encdatasz);
	free (encdata);
	return 0;
}

/** 
 * @brief This function decrypts the data specified by the
 *        user.
 * 
 * @param pArgc [in]        number of input values
 * @param pArgv [in]		input values
 * @param pResult [out]     decrypted out buffer, this function allocates the buffer, user needs to release it
 * @param pResultSize [out] out buffer length
 * 
 */
extern "C" HRESULT __declspec (dllexport)
DecryptData (short pArgc, wchar_t ** pArgv, wchar_t ** pResult, long * pResultSize)
{	
		char *		data;
		char *		key;
		char *		decdata;
		long		datasz, keysz, decdatasz;
		
	//get decrypted data length
	datasz = wcslen (pArgv[0]) + 1;
	keysz = wcslen (pArgv[1]) + 1;

	//allocate memory
	data = (char*)calloc (datasz, sizeof (char));
	key = (char*)calloc (keysz, sizeof (char));

	//convert unicode to ansi
	WideCharToMultiByte (CP_ACP, 0, (LPCWSTR)pArgv[0], -1, data, datasz, NULL, NULL );
	WideCharToMultiByte (CP_ACP, 0, (LPCWSTR)pArgv[1], -1, key, keysz, NULL, NULL );

	//decrypt data
	decdata = decrypt_data (data, key, decdatasz);

	//free the temp allocate buffers
	free (data);
	free (key);
	
	//copy the decrypted and convert to unicode
	*pResultSize = 1024+1; //(encdatasz + 1) * sizeof (wchar_t);
	*pResult = static_cast<wchar_t *>(CoTaskMemAlloc (*pResultSize));
	memset (*pResult, 0, *pResultSize);

	MultiByteToWideChar (CP_ACP, 0, decdata, decdatasz, *pResult, decdatasz);
	free (decdata);

	return 0;
}

/** 
 * @brief This function performs the hex conversion of the
 *        data specified by the user and decrypts it.
 * 
 * @param pData [in]        data to be decrypted
 * @param pKey [in]			decryption key 
 * @param pOutBuf [out]     out buffer, this function allocates the buffer in case of success and user needs
 *                to free the buffer
 * @param pOutBufLen [out]  out buffer length 
 */
extern "C" HRESULT __declspec (dllexport)
DecryptStr (char * pData, char *pKey, char ** pOutBuf, unsigned long * pResultSize)
{
		char *		data;
		char *		decdata;
		long		datasz, decdatasz;

	//get the encrypted data length
	datasz = strlen (pData) + 1;
	
	//allocate memory
	data = (char*)calloc (datasz, sizeof (char));
	strcpy(data, pData);

	//decrypt data
	decdata = decrypt_data (data, pKey, decdatasz);

	//free temp allocated buffer
	free (data);

	//copy the decrypted buffer
	*pResultSize = decdatasz;
	memset (*pOutBuf, 0, decdatasz);
	memcpy (*pOutBuf, decdata, decdatasz);

	free (decdata);

	return 0;
}

/** 
 * @brief This function encrypts the data specified by the
 *        user using XOR encryption and converts encrypted data to hex string.
 * 
 * @param pInput [in]       data to be encrypted
 * @param pKey [in]			encryption key 
 * 
 * @return char*, return hex string
 */
char* encrypt_data(char* pInput, char* pKey)
{
		int		datasz;
		int		key_count;
		int		key_len;
		char*	encrypt_byte;
		char *	hex;

	//initialize
	datasz		= strlen (pInput);
	key_count	= 0;
	key_len		= strlen(pKey);

	//allocate memory
	encrypt_byte = (char*) calloc (datasz, sizeof (char));

	//perform XOR encryption
	for(int i = 0; i < datasz; i++) {
		encrypt_byte[i] = pInput[i] ^ pKey[key_count];

		//Increment key_count and start over if necessary
		key_count++;
		if(key_count == key_len)
			key_count = 0;
	}

	//converts binary to hex
	hex = StrToHexStr (encrypt_byte, datasz);
	
	return hex;
}

/** 
 * @brief This function data specified by the user to hex string.
 * 
 * @param pEncStr [in]		encrypted data
 * @param pEncLen [in]		encrypted data length 
 * 
 * @return char*, return hex string
 */
char *StrToHexStr(char* pEncStr, long pEncLen) 
{ 
		char *	newstr;
		char *	cpold;
		char *	cpnew;
		long	strlen;

	//initialize
	strlen	= pEncLen * 2;
	newstr	= (char*) calloc (strlen+1, sizeof (char)); 
	cpold	= pEncStr; 
	cpnew	= newstr; 

	while(pEncLen > 0) {
		//prints to hex char in buffer
		sprintf(cpnew, "%02X", (char)(*cpold++)); 
		cpnew+=2; 

		pEncLen--;
	} 
	//*(cpnew) = '\0'; 
	
	return(newstr); 
}

/** 
 * @brief This function converts the hex string into encypted string
 *			and decrypts.
 * 
 * @param pInput [in]       data to be decrypted
 * @param pKey [in]			decryption key 
 * @param pDecData [out]	decrypted data length
 * 
 * @return ULong, returns decrypted output
 */
char* decrypt_data(char* pInput, char* pKey, long & pDecData)
{
		int		datasz;
		int		key_count;
		int		key_len;
		char*	encrypt_byte;
		char*	str;

	//initialize	
	key_count	= 0;
	key_len		= strlen(pKey);

	str = Hex2Char (pInput, strlen(pInput));

	datasz		= strlen (pInput)/2;
	pDecData	= datasz;
	encrypt_byte = (char*) calloc (datasz, 1);

	for(int i = 0; i < datasz; i++) { 
		encrypt_byte[i] = str[i] ^ pKey[key_count];

		//Increment key_count and start over if necessary
		key_count++;
		if(key_count == key_len)
			key_count = 0;
	}
	encrypt_byte[datasz] = '/0';
	return encrypt_byte;
}

/** 
 * @brief This function converts the hex chars into a char.
 * 
 * @param pValue [in]       hex chars
 * 
 * @return ULong, returns a char
 */
int HexDm(char * pValue)
{
        int		i;
		int		j;
		int		val;
		int		cnt;
        char	vals []="0123456789ABCDEF";
        char	c;
        bool	found;

	//initialize
	val	= 0;
	cnt	= strlen(pValue);

    for(i=cnt-1; i>=0; i--) {
		c = pValue[i];
        found = false;
            
		for(j=0; j<16 && !found; j++) {
			if(toupper(c) == vals[j]) {
				found = true; 
				break;
			}
		}
        val += j * ((int)pow(16.0, cnt-1-i));
	}

    return val;
}

/** 
 * @brief This function converts the hex string into encypted string
 *			and decrypts.
 * 
 * @param pDecStr [in]		data to convert into hex string
 * @param pLen [in]			data length
 * 
 * @return ULong, returns decrypted output
 */
char* Hex2Char(char* pDecStr, long pLen)
{
        int		NbrOfVal;
        int		len;
        int		i, k;
        char *key, *result, *in;

	//initialize
	len			= pLen;
	in			= pDecStr;
    NbrOfVal	= len/2;

    if(len % 2 !=0)
		return NULL;

	//allocate the result buffer
    result = new char [NbrOfVal+1];

    k = 0;
	//allocate buffer to hold hex chars
    key = (char*)calloc(3, sizeof (char));

	//walk the hex string
    for(i=0; i<NbrOfVal; i++,k+=2) {
		//get 2 chars at a time
        key[0] = in[k];
        key[1] = in[k+1];

		//convert hex chars to a char
        result[i] = (char)HexDm(key);
    }

    result[i]='\0';

    return result;
}