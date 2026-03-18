using "win32a.inc";


// Сам рантайм
void qsr_len_string ()
{
	asm
	push edi;
    xor ebx, ebx;
    .next_iter:;
        cmp [edi+ebx], byte 0;
        je .close;
        inc ebx;
        jmp .next_iter;
    .close:;
        pop edi;
		ret;
	asm
}
void qsr_uint_to_str()
{
	asm
	push ebx;
    push ecx;
    push edx;
    mov edi, qsr.Console.ConsoleBuffer + 11;
    mov byte [edi], 0;
    dec edi;
    mov ebx, 10;
    test eax, eax;
    jnz .convert;
    mov byte [edi], '0';
    jmp .done;
.convert:;
    xor edx, edx;
    div ebx;
    add dl, '0';
    mov [edi], dl;
    dec edi;
    test eax, eax;
    jnz .convert;
.done:;
    inc edi;
    pop edx;
    pop ecx;
    pop ebx;
    ret;
	asm
}

// << Консольное Внутре рантаймовое >>
//Макросы
inline qsr.printf (int32 message)
{
	asm
    push ebx;
    mov edi, message;
    call qsr_len_string;
    push 0;
    push qsr.Console.ConsoleTempPtr;
    push ebx;
    push edi;
    push [qsr.Console.ConsoleHandle];
    call [WriteConsoleA];
    pop ebx;
	asm
}
inline qsr.printfl (int32 message)
{
	asm
	push message;
	push strFormat;
	call [printf];
	add esp, 8;
	Console.endl;
	asm
}
inline qsr.printc ()
{
	asm
	mov [qsr.Console.ConsoleChar], al; 
    push ebx;
    push 0;
    push qsr.Console.ConsoleTempPtr;
    push 1;
    push qsr.Console.ConsoleChar;
    push [qsr.Console.ConsoleHandle];
    call [WriteConsoleA];
    pop ebx;
	asm
}
inline qsr.printv (int32 message)
{
	asm
	push message;
	push varFormat;
	call [printf];
	add esp, 8;
	asm
}
inline qsr.printva (int32 message)
{
    asm
	push ebx;
    push eax;
    mov eax, [message];
    call qsr_uint_to_str;
    call qsr_len_string;
    push 0;
    push qsr.Console.ConsoleTempPtr;
    push ebx;
    push edi;
    push [qsr.Console.ConsoleHandle];
    call [WriteConsoleA];
    pop eax;
    pop ebx;
	asm
}
inline qsr.printvaf (int32 message)
{
    asm
	sub esp, 8;
    fld dword [message];
    fstp qword [esp];
    push floatFormat;
    call [printf];
    add esp, 12;
	asm
}
//Функции
int32 qsr.getTick (int32 var)
{
	int32 resualt;
	asm
	invoke GetTickCount
	mov [resualt], eax
	asm
	return resualt;
}
// << ----------------------------- >>

// Консольно Используемое
inline Console.getch () //invoke ReadConsoleA, [qsr.Console.ConsoleHandle], qsr.Console.ConsoleCharBuffer, 1, qsr.Console.ConsoleBytesRead, 0;
{
	asm
	call [getch];
	asm
}
inline Console.endl ()
{
	asm
	push endl;
	push strFormat;
	call [printf];
	add esp, 8;
	asm
}
inline Console.cin (int32 var)
{
	asm
	lea eax, [var];
	push eax;
	push varFormat;
	call [scanf];
	add esp, 8;
	asm
}
inline Console.clear ()
{
	asm
	invoke  WriteConsoleA, [qsr.Console.ConsoleHandle], clear, 6, qsr.Console.ConsoleTempPtr, 0;
	asm
}
void Console.Write(int32 form, int32 data)
{
	int32 format;
	asm
	mov eax, [form];
	cmp [eax], word '%s';
	je .ConsoleWrite.fl1;
	jne .ConsoleWrite.fl2;
	.ConsoleWrite.fl1:;
	mov [format], 0;
	jmp .ConsoleWrite.fl;
	.ConsoleWrite.fl2:;
	mov [format], 1;
	.ConsoleWrite.fl:;
	asm
	if (format == 0)
	{
		asm
		mov eax, [data];
		asm
		qsr.printf(eax);
	}
	if (format == 1)
	{
		qsr.printva(data);
	}
}
void Console.WriteLine(int32 form, int32 data)
{
	int32 format;
	asm
	mov eax, [form];
	cmp [eax], word '%s';
	je .ConsoleWriteLine.fl1;
	jne .ConsoleWriteLine.fl2;
	.ConsoleWriteLine.fl1:;
	mov [format], 0;
	jmp .ConsoleWriteLine.fl;
	.ConsoleWriteLine.fl2:;
	mov [format], 1;
	.ConsoleWriteLine.fl:;
	asm
	if (format == 0)
	{
		asm
		mov eax, [data];
		asm
		qsr.printf(eax);
	}
	if (format == 1)
	{
		qsr.printva(data);
	}
	Console.endl();
}
void write(int32 form, int32 data)
{
	int32 format;
	asm
	mov eax, [form];
	cmp [eax], word '%s';
	je .ConsoleWrite.fl1;
	jne .ConsoleWrite.fl2;
	.ConsoleWrite.fl1:;
	mov [format], 0;
	jmp .ConsoleWrite.fl;
	.ConsoleWrite.fl2:;
	mov [format], 1;
	.ConsoleWrite.fl:;
	asm
	if (format == 0)
	{
		asm
		mov eax, [data];
		asm
		qsr.printf(eax);
	}
	if (format == 1)
	{
		qsr.printva(data);
	}
}
void writeln(int32 form, int32 data)
{
	int32 format;
	asm
	mov eax, [form];
	cmp [eax], word '%s';
	je .ConsoleWriteLine.fl1;
	jne .ConsoleWriteLine.fl2;
	.ConsoleWriteLine.fl1:;
	mov [format], 0;
	jmp .ConsoleWriteLine.fl;
	.ConsoleWriteLine.fl2:;
	mov [format], 1;
	.ConsoleWriteLine.fl:;
	asm
	if (format == 0)
	{
		asm
		mov eax, [data];
		asm
		qsr.printf(eax);
	}
	if (format == 1)
	{
		qsr.printva(data);
	}
	Console.endl();
}

// Внутринии структуры и их функции

// Array
struct Array <T>
{
	T Items;
	int32 Count;
	int32 ItemSize;
}
inline Array.init(int32 list, int32 len, int32 size)
{
	asm
	mov [list +Array_int32.Items], esp;
	mov eax, size;
	mov ebx, len;
	imul eax, ebx;
	sub esp, eax;
	mov eax, len;
	mov [list +Array_int32.Count], eax;
	mov [list +Array_int32.ItemSize], size;
	asm
}
inline Array.clear(int32 list)
{
	asm
	mov eax, [list.Count];
	mov ebx, [list.ItemSize];
	imul eax, ebx;
	add esp, eax;
	mov [list.Items], 0;
	mov [list.Count], 0;
	mov [list.ItemSize], 0;
	asm
}
// Array End


// Инициализация рантайма
inline qsr.GetConsoleHandle()
{
	asm
    invoke GetStdHandle, STD_OUTPUT_HANDLE;
    mov [qsr.Console.ConsoleHandle], eax;
    xor eax, eax;
	asm
}
inline qsr.init()
{
	qsr.GetConsoleHandle();
	//qsr.printfl("<<< QscriptNt Console >>");
}

struct console {
	int32 ConsoleHandle;
	int32 ConsoleBuffer;
	int32 ConsoleTempPtr;
	int8 ConsoleCharBuffer;
	int8 ConsoleChar;
	int32 ConsoleBytesRead;
}

struct Qsr {
	console Console;
}

// data
Qsr qsr?;


// Testing
qsr.init();

// Array Testing
Array<int32> list?;
Array.init(list, 10, 4);
int32 i = 0;
iter (10) { list.Items[i] = i+i; i+=1; }
Console.Write("%s", "list.Items[5]=");Console.WriteLine("%d", list.Items[9]); // |0|2|4|6|8|10|12|14|16|18|
// Array Testing End


// Console.Write Testing
Console.WriteLine("%s", "FDF");
Console.Write("%s", "Console.ConsoleHandle = "); Console.WriteLine("%d", qsr.Console.ConsoleHandle);
Console.WriteLine("%d", 12);
int32 sd = 32;
Console.WriteLine("%d", sd);
// Console.Write Testing End

// Return in signature Testing
int32 fntest1 () {return 32;}
Console.WriteLine("%d", fntest1());
// Return in signature Testing End

// Return in signature Testing
int32 fntest2 (int32 n) {return n+n;}
Console.WriteLine("%d", fntest2(64));
writeln("%d", fntest2(128+128)); write("%s", "Testing"); writeln("%d", 1);
// Return in signature Testing End

void printq(int32 data) <T>
{
	int32 format = 1;
	T form; 
	asm
	mov [form], 250
	add [form], 10
	jc .trueP
	jmp .falseP
	.trueP:
	mov [format], 0
	.falseP:
	asm
	
	if format == 0
	{
		asm
		mov eax, [data];
		asm
		qsr.printf(eax);
	}
	if format == 1
	{
		qsr.printva(data);
	}
}

Console.endl();
printq<string>("print(");
printq<int32>(3);
printq<string>(")");


Console.endl();
printq<string> ("Fuck Off");

Array<int32> gchars?;
Array.init(gchars, 16, 4);
int32 gcharsI; iter (16)
{ gchars.Items[gcharsI] = 0; gcharsI+=1; }
asm
mov eax, [gchars.Items];
add eax, 4
push eax;
push strFormat;
call [scanf];
add esp, 8;
asm
int32 chsi = 0;

//sizeof(chsi);
//eax = sizeof.refvar;
//eax = &refvar;
//al = gchars.Items[1];

int32 adsd = sizeof.chsi + sizeof.gchars;

iter (64) {
	//gchars.Items[chsi] = 12;
	int8 dff;
	int32 dffs;
	asm
		mov eax, [chsi]
		mov ecx, eax
		mov ebx, [gchars.Items]
		mov al, byte [ebx+ecx]
		cmp al, ' '
		je fsff
		cmp al, 0
		je fsff
	asm
		qsr.printc(); //gchars.Items[chsi]
	asm
	fsff:
	asm
	chsi+=1;
}

//int8 dga;
asm
mov eax, [gchars.Items]
push eax
push strFormat
call [printf]
add esp, 8
asm

// Testing UnarOper
Console.endl();
int32 size = 5;
printq<int32>(++size);
printq<int32>(size++);
Console.endl();
printq<int32>(size);
// Testing UnarOper End

// Testing Address
printq<int32>(&size);
Console.endl();
// Testing Address End

// Testing SizeOf 
int16 sizeofTest;
printq<int32>(sizeof.sizeofTest);
Console.endl();
printq<int32>(sizeof.list);
Console.endl();
// Testing SizeOf End

printq<string>("ds");
Console.endl();


if (12.4f >= 12.3f)
{
	printq<int8>("12.4f >= 12.3f");
}
if (sizeof.list < 256)
{
	printq<int8>("push in low pool");
}

Console.getch();
int32 tick = qsr.getTick();
//enumerator int32 ienum, (100)
//for (int32 fori = 0; fori < 100000; fori++)
//{
	//if (ienum == 0) { printq<string>("0");}
	//qsr.printva(fori);
	//Console.endl();
//}
tick = qsr.getTick() - tick;
printq<string>("Tick:");
printq<int32>(tick);
Console.endl();
printq<int32>(&size);


int32 tick2 = qsr.getTick();
//int32 recurse (int32 iii, int32 zzz)
//{
    //if (zzz > 0) { return recurse(iii + 1, zzz - 1); }
	//else { return iii + iii; }
//}
//int32 dsss = recurse(1, 10000);
int32 fibonacci (int32 nnn)
{
    if (nnn == 0 || nnn == 1)
	{
		return nnn;
	}
    else 
	{
		return fibonacci(nnn - 1) + fibonacci(nnn - 2);//fibonacci(nnn - 1) + fibn2;
	}
}

//int32 dsss = fibonacci(36);
//iter (1000) { printq<int8>("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"); }
tick2 = qsr.getTick() - tick2;
//printq<int8>("Value:"); qsr.printva(dsss); Console.endl();
printq<string>("Tick:");
printq<int32>(tick2);


struct Nums <T>
{
	T Items;
	int32 Count;
	int32 ItemSize;
}
void Nums.init(Nums<T> list2, int32 len2, int32 size2) <T>//, int32 size)
{
	//int32 sizeItem = sizeof.list.Items
	
	asm
	mov [list2.Items], esp
	mov eax, size2
	mov ebx, len2
	imul eax, ebx
	sub esp, eax
	asm
	
	list2.Count = len2;
	list2.ItemSize = size2;
}

Nums<int32> numbers?;
Nums.init<int32>(numbers, 10, 4);

int32 irepn = ((23+42/2)/2 + (1+3) )+ -25;
int32 testConstVar = 12;
int32 testConstVar2 = testConstVar;
if (testConstVar == testConstVar2) { testConstVar = 13; }
if (12 == 12) {}
int32 mmll () { return 1; }
Nums<int32>* GgG = mmll();
rept 10
{
	Console.endl();
	int32 irepnv = numbers.Items[irepn];
	qsr.printva(irepnv);
	irep++;
}
int32* array = mmll();
int32 irep = 1;
rept 10
{
	Console.endl();
	qsr.printva(irep);
	irep++;
}
class WindowProgram {
int32 as;
int32 as2;
WindowProgram () {
	this.as = 12;
	this.as2 = 32;
}
void func () {}
}
using "lib/opengl.inc";



inline CreateWindow (int32 w, int32 h)
{
	asm
    invoke CreateWindowEx,0,ClassName,WindowTitle,\
           WS_VISIBLE+WS_OVERLAPPEDWINDOW,\
           100,100,w,h,0,0,[Instance],0
    asm
}

int32 Instance;

class Window {

     int32 Style
	 int32 lpfnWndProc
	 int32 cbClsExtra
	 int32 cbWndExtra
	 int32 hInstance
	 int32 hIcon
	 int32 hCursor
	 int32 hbrBackground
	 string* lpszMenuName
	 string* lpszClassName

     int32 hWindow

    void Create (int32 w, int32 h, string* className, string* windowTitle)
	{
		asm
		push ebx
        push esi
        push edi

        mov edx, [this]
		mov ecx, [className]
		mov [edx + Window.lpszClassName], ecx

		mov edx, [this]
		mov ecx, [windowTitle]
		mov [edx + Window.lpszMenuName], ecx
        asm

        asm
		mov eax, WindowProc
        mov [edx + Window.lpfnWndProc], eax
		asm

		asm
	    invoke GetModuleHandle,0
        mov [edx + Window.hInstance],eax
		//mov ecx, [this]
		push edx
        call [RegisterClassA]
	    asm
		asm
		mov edx, [this]
		mov eax, [edx + Window.lpszClassName]
		mov ebx, [edx + Window.lpszMenuName]

        //mov ecx, [this]
		push 0         
        push [edx + Window.hInstance]                                
        push 0                
        push 0
        push [h]
        push [w]
        push 100                                   
        push 100                                  
        push WS_VISIBLE+WS_OVERLAPPEDWINDOW       
        push ebx                                  
        push eax                              
        push 0                                  
        call [CreateWindowExA]
		
	    mov [edx + Window.hWindow], eax

        pop edi
        pop esi
        pop ebx
		//push eax
        //push GWL_USERDATA
		//lea ecx, [this]
        //push ecx
        //call [SetWindowLongPtrA]

        mov eax, [this]
		mov [WindowContext + SystemWindowContext.window], eax
		asm
	}
	void Update ()
	{
		printq @string ("Window Update!") Console.endl()
	}
}


void WindowProc (int32 hwnd, int32 wmsg, int32 wparam, int32 lparam)
{
	asm
	cmp [wmsg],WM_DESTROY
    je .wmdestroy
	//mov eax, Update_Window
	//call eax
	asm
	WindowContext.window.Update()
    asm
    invoke DefWindowProcA,[hwnd],[wmsg],[wparam],[lparam]
    ret
.wmdestroy:
    invoke PostQuitMessage,0
    xor eax,eax
    ret
    asm
}

struct SystemWindowContext {
	Window* window
}

SystemWindowContext WindowContext?
extern-func void glClearColor2 (float r, float g, float b, float a) from kernel  
extern-func void glClearColor (float r, float g, float b, float a) from kernel
define sPOOL 1212
glClearColor(1f,1f,1f,1f)
//string* ClassName = "ClassName";
//string* WindowTitle = "Title";
class List @T
{
    T* Items
    int32 Count
    
    T* getItemsPtr () { return T }
}

List @int32 list22? int32 dsagsdfgaf = list22.getItemsPtr()
WindowProgram window;
window.func();
Console.getch();
//
int32 sasa1 = 15;
int32 sasa = sasa1 % 2;
int32 KEYTEST;
asm
section '.data' data readable writable;
    varFormat db '%d', 0;
    strFormat db '%s', 0;
	floatFormat db '%f', 0;
	endl db 10, 13, '', 0;
	clear db 1Bh, '[2J', 1Bh, '[H', 0;
	STD_OUTPUT_HANDLE = -11;
asm
asm
section '.idata' import data readable;
            library kernel, 'kernel32.dll',\;
                    msvcrt, 'msvcrt.dll',\;
                    user, 'user32.dll';
            import kernel,\;
                ExitProcess, 'ExitProcess',\;
                SetConsoleTitle, 'SetConsoleTitleA',\;
                GetStdHandle, 'GetStdHandle',\;
                SetConsoleTextAttribute, 'SetConsoleTextAttribute',\;
                SetConsoleCursorPosition, 'SetConsoleCursorPosition',\;
                GetProcessHeap, 'GetProcessHeap',\;
                HeapAlloc, 'HeapAlloc',\;
                HeapFree, 'HeapFree',\;
                VirtualAlloc, 'VirtualAlloc',\;
                VirtualFree, 'VirtualFree',\;
                WriteConsoleA, 'WriteConsoleA',\;
				ReadConsoleA, 'ReadConsoleA',\;
				GetTickCount, 'GetTickCount';
            import msvcrt,\;
                printf, 'printf',\;
                getch, '_getch',\;
                scanf, 'scanf';
            import user,\;
                MessageBox, 'MessageBoxA';
asm
