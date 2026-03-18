using "lib/win32a.inc";


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
int32 qsr.getTick ()
{
	int32 resualt;
	asm
	invoke GetTickCount
	mov [resualt], eax
	asm
	return resualt;
}
int32 malloc (int32 size)
{
	/// * Что мы здесь должны сделать
	//  * Сохранение Pool End для указателя на выделеную память +4 от заголовка
	//  * А потом Изменить методанные Pool
	/// *
	size += 4; // Ну первым шагом нужно добавить размер заголовка
	int32 resualtPtr;

    resualtPtr = qsr.Pool.PoolEnd + 4;
	asm
	mov ecx, [qsr.Pool.PoolEnd]
	mov edx, [size]
	sub edx, 4
    mov [ecx], edx
	asm
	qsr.Pool.PoolEnd += size;
	qsr.Pool.PoolTotalSize += size;
	qsr.Pool.PoolItemCount++;

    return resualtPtr;
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
	lea ecx, [list]
	mov [ecx], esp

    mov eax, size
	mov ebx, len
	imul eax, ebx
	sub esp, eax
	mov eax, len
	
	lea ecx, [list]
	add ecx, 4
	mov [ecx], dword eax
	
	lea ecx, [list]
	add ecx, 8
    mov [ecx], dword size
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
inline qsr.GetHeapHandle()
{
	asm
	invoke GetProcessHeap
	mov [qsr.Heap.Handle], eax
	//test eax, eax
	//mov eax, 1
	//jz Error
	xor eax, eax
    asm
}
inline qsr.AllocPool(int32 poolSize)
{
	asm
    push dword [poolSize]
	push dword HEAP_ZERO_MEMORY
	push dword [qsr.Heap.Handle]
	call [HeapAlloc]
	//test eax, eax
	//mov eax, 2
    //jz Error
	mov [qsr.Pool.PoolPtr], eax
	mov ecx, [poolSize]
	mov [qsr.Pool.PoolMaxSize], ecx
	mov [qsr.Pool.PoolEnd], eax
    asm
}

inline qsr.PoolPrint()
{
	printq<string>("HeapHandle = "); printq<int32>(qsr.Heap.Handle); Console.endl();
	printq<string>("PoolPtr = "); printq<int32>(qsr.Pool.PoolPtr); Console.endl();
	printq<string>("PoolTotalSize = "); printq<int32>(qsr.Pool.PoolTotalSize);
	Console.endl();
    printq<string>("PoolMaxSize = "); printq<int32>(qsr.Pool.PoolMaxSize); Console.endl();
	printq<string>("PoolItemCount = "); printq<int32>(qsr.Pool.PoolItemCount);
	Console.endl();
}

void qsr.init(int32 poolSize)
{
	qsr.GetConsoleHandle();

    // Alloc Pool
	qsr.GetHeapHandle();
	qsr.AllocPool(poolSize);

    qsr.printfl("<<< QscriptNt Console >>");
}

struct heap
{
	int32 Handle;
	int32 Error;
}

struct poolFrame
{
	int32 PoolPtr;
	int32 PoolMaxSize;
	int32 PoolTotalSize;
	int32 PoolEnd;
	int32 PoolItemCount;
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
	poolFrame Pool;
	heap Heap;
}

// const
int32 PoolSegment = 1024;                // 1024 bat
int32 PoolSegments = PoolSegment * 1536; // 96 mbat

// data
Qsr qsr?;


// Testing
qsr.init(PoolSegments);

int32 arrayHeapTest = malloc(40); // 10 * 4 = 40 + 4 = 44

enumerator int32 arrayHeapTestI, 10
{
	arrayHeapTest[arrayHeapTestI] = arrayHeapTestI;
}

arrayHeapTest[5] = 3232;
//printq<int32>(arrayHeapTest[5]);

enumerator int32 arrayHeapTestI2, 10
{
	printq<int32>(arrayHeapTest[arrayHeapTestI2]);
	Console.endl();
}

struct Person
{
	int32 age;
}
Person* qrell;
qrell = malloc(4); // 4198869
asm
mov ecx, [qrell]
mov dword [ecx], 14
asm
int32 age;
asm
mov ecx, [qrell]
mov edx, [ecx]
mov eax, edx
mov [age], eax
asm
printq<int32>(age);


Console.endl();
qsr.PoolPrint();


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
		asm
		cmp [data], 0
		jne .falseD
		asm
		qsr.printf("0");
		asm
        .falseD:
		asm
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
    if (nnn <= 1)
	{
		return nnn;
	}
    else 
	{
		//if (nnn <= 1)
	    //{ return nnn; }
        //else { return fibonacci(nnn - 1) + fibonacci(nnn - 2); }
		
		return fibonacci(nnn - 1) + fibonacci(nnn - 2);//fibonacci(nnn - 1) + fibn2;
	}
}


int32 dsss = fibonacci(36);
//iter (1000) { printq<int8>("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"); }
int32 tick2_temp = qsr.getTick();
tick2 = tick2_temp - tick2;
//printq<int8>("Value:"); qsr.printva(dsss); Console.endl();
printq<string>("Tick Fibonacci:");
printq<int32>(tick2);

Array<int32>* sudo = &list;
Console.endl(); printq<string>("Sudo"); printq<int32>(sudo); Console.endl();
Array<int32>* sudo2 = &sudo;
Console.endl(); printq<string>("Sudo2"); printq<int32>(sudo2); Console.endl();

struct Nums <T>
{
	T* Items;
	int32 Count;
	int32 ItemSize;
}

inline Nums.init (int32 list, int32 len, int32 size)
{
	asm

    lea ecx, [list]
	mov [ecx], esp

    mov eax, size
	mov ebx, len
	imul eax, ebx
	sub esp, eax
	mov eax, len
	
	lea ecx, [list]
	add ecx, 4
	mov [ecx], dword eax
	
	lea ecx, [list]
	add ecx, 8
    mov [ecx], dword size

    asm
}

Nums<int32> numbers?;
Nums.init(numbers, 10, 4);

enumerator int32 ini, 10//for (int32 ini = 0; ini < numbers.Count; ini++)
{
	numbers.Items[ini] = 0;
}

numbers.Items[0] = 12;
numbers.Items[2] = 32;
numbers.Items[9] = 64;

Console.endl(); printq<int8>("Numbers.Items: "); printq<int32>(numbers.Items);
Console.endl(); printq<int8>("Numbers.Count: "); printq<int32>(numbers.Count);
Console.endl(); printq<int8>("Numbers.ItemSize: "); printq<int32>(numbers.ItemSize);

printq<int8>("9 => "); printq<int32>(numbers.Items[9]); Console.endl();

enumerator int32 ni, 10 //for (int32 ni = 0; ni < numbers.Count; ni++)
{
	Console.endl();
	printq<int8>("Items["); qsr.printva(ni); printq<int8>("] = ");
	printq<int32>(numbers.Items[ni]);
}


Nums<string> StringTest?;
Nums.init(StringTest, 32, 1);

enumerator int32 strI1, 32
{ StringTest.Items[strI1] = 0; }

asm
mov eax, [StringTest.Items]

push eax
push strFormat
call [scanf]
add esp, 8
asm

asm
mov eax, [StringTest.Items]
push eax
push strFormat
call [printf]
add esp, 8
asm

Console.endl();
StringTest.Items[0] = 'H';
StringTest.Items[1] = 'E';
StringTest.Items[2] = 'L';
StringTest.Items[3] = 'L';
StringTest.Items[4] = 'O';
printq<int8>(StringTest.Items);
StringTest.Items = "Player";
printq<int8>(StringTest.Items);

struct StringArray
{
	int8* value;
	int32 count;
	int32 itemSize;
}
struct String
{
	int8* str;
}

String fg?;
fg = "Hello World!!";
Console.endl(); printq<string>(fg);

StringArray testStr?;
//newString(testStr, 100);
//testStr.value = "Hello HyeSos!!!";
testStr.value = "String Testing1...";
Console.endl();
printq<string>(testStr);

testStr.value = "String Testing2...";
Console.endl();
printq<string>(testStr);


//== --- --- --- --- --- --- ==
String ifStrTest?;
ifStrTest = "test";
if (ifStrTest == "test")
{
	printq<string>("== -- test == test -- ==");
}
//== --- --- --- --- --- --- ==



int32 irepn = 1;
rept 10
{
	//Console.endl();
	//int32 irepnv = numbers.Items[irepn];
	//qsr.printva(irepnv);
	//irep++;
}


int32 irep = 1;
rept 10
{
	Console.endl();
	qsr.printva(irep);
	irep++;
}

Console.getch();
//

using section {
asm
section '.data' data readable writable;
    varFormat db '%d', 0;
    strFormat db '%s', 0;
	floatFormat db '%f', 0;
	endl db 10, 13, '', 0;
	clear db 1Bh, '[2J', 1Bh, '[H', 0;
	STD_OUTPUT_HANDLE = -11;
	STD_INPUT_HANDLE = -10

    MEM_COMMIT = 1000h
	MEM_RESERVE = 2000h
	PAGE_READWRITE = 4h
	
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
				
}
