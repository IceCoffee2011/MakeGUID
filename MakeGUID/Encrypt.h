#ifndef ENCRYPT_HEAD_FILE
#define ENCRYPT_HEAD_FILE

//#include "ComService.h"

//////////////////////////////////////////////////////////////////////////

//MD5 ������
class CMD5Encrypt
{
	//��������
private:
	//���캯��
	CMD5Encrypt() {}

	//���ܺ���
public:
	//��������
	static void EncryptData(LPCSTR pszSrcData, CHAR szMD5Result[33]);
};

//////////////////////////////////////////////////////////////////////////

//6601��������<��Կ����Ϊ5>
class CXOREncryptA
{
	//��������
private:
	//���캯��
	CXOREncryptA() {}

	//���ܺ���
public:
	//��������
	static WORD EncryptData(LPCSTR pszSrcData, LPSTR pszEncrypData, WORD wSize);
	//�⿪����
	static WORD CrevasseData(LPCSTR pszEncrypData, LPSTR pszSrcData, WORD wSize);
};

//6603��������<��Կ����Ϊ8>
class CXOREncryptW
{
	//��������
private:
	//���캯��
	CXOREncryptW() {}

	//���ܺ���
public:
	//��������
	static WORD EncryptData(LPCWSTR pszSourceData, LPWSTR pszEncrypData, WORD wMaxCount/*unsigned char * pszSrcData, unsigned char* pszEncrypData, WORD wSize*/);
	//�⿪����
	static WORD CrevasseData(LPCWSTR pszEncrypData, LPWSTR pszSourceData, WORD wMaxCount/*unsigned char * pszEncrypData, unsigned char* pszSrcData, WORD wSize*/);
};

//////////////////////////////////////////////////////////////////////////

#endif