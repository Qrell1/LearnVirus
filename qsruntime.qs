using "win32a.inc";


inline qs_printf (int32 message)
{
	asm
    push ebx;
    mov edi, message;
    call qs_len_string;
    push 0;
    push tptr;
    push ebx;
    push edi;
    push [hConsole];
    call [WriteConsoleA];
    pop ebx;
	asm
}
inline qs_gethConsole()
{
	asm
    invoke GetStdHandle, STD_OUTPUT_HANDLE;
    mov [hConsole], eax;
    xor eax, eax;
	asm
}
void qs_len_string ()
{
	asm
	push edi;
    xor ebx, ebx;
    .next_iterLS:;
        cmp [edi+ebx], byte 0;
        je .closeLS;
        inc ebx;
        jmp .next_iterLS;
    .closeLS:;
        pop edi;
		ret;
	asm
}
void qs_convert_float_to_string(int32 var)
{
	asm
    push eax ;
    push ebx ;
    push ecx ;
    push edx ;
    sub esp, 8 ;
    movd [esp], xmm0 ;
    mov eax, [esp] ;
    test eax, 0x80000000 ;
    jz .positive2 ;
    mov byte [edi], '-' ;
    inc edi ;
    and dword [esp], 0x7FFFFFFF ;
.positive2: ;
    fld dword [esp] ;
    fmul qword [var] ;
    fistp qword [esp] ;
    mov eax, [esp] ;
    mov edx, [esp+4] ;
    mov ebx, 1000000 ;
    div ebx ;
    push edx ;
    call qs_uint_to_str ;
    pop edx ;
    mov byte [edi], '.' ;
    inc edi ;
    mov eax, edx ;
    mov ecx, 6 ;
    mov ebx, 100000 ;
.fraction_loop2: ;
    xor edx, edx ;
    div ebx ;
    add al, '0';
    mov [edi], al;
    inc edi ;
    mov eax, edx;
    xor edx, edx;
    mov ebx, 10;
    div ebx ;
    push edx ;
    mov eax, ecx ;
    dec eax ;
    mov ebx, 10;
    mov ecx, eax ;
    pop eax ;
    jecxz .done_frac;
    loop .fraction_loop2;
.done_frac: ;
    mov byte [edi], 0 ;
    add esp, 8 ;
    pop edx ;
    pop ecx ;
    pop ebx ;
    pop eax ; 
    ret ; 
	asm
}
void qs_uint_to_str()
{
	asm
	push ebx;
    push ecx;
    push edx;
    mov edi, qs.buffer + 11;
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
inline qs_printfl (int32 message)
{
	asm
	push message;
	push strFormat;
	call [printf];
	add esp, 8;
	qs_endl;
	asm
}
inline qs_printv (int32 message)
{
	asm
	push message;
	push varFormat;
	call [printf];
	add esp, 8;
	asm
}
inline qs_printva (int32 message)
{
    asm
	push ebx;
    push eax;
    mov eax, [message];
    call qs_uint_to_str;
    call qs_len_string;
    push 0;
    push tptr;
    push ebx;
    push edi;
    push [hConsole];
    call [WriteConsoleA];
    pop eax;
    pop ebx;
	asm
}
inline qs_printvaf (int32 message)
{
    asm
	sub esp, 8;
    fld dword [message];
    fstp qword [esp];
    push floatFormat;
    call [printf];
    add esp, 12
	asm
}
inline qs_getch ()
{
	asm
	call [getch];
	asm
}
inline qs_endl ()
{
	asm
	push endl;
	push strFormat;
	call [printf];
	add esp, 8;
	asm
}
inline qs_for (int32_a f, int32_a count)
{
	asm
    xor ecx, ecx;
	mov edx, count;
    f:;
	push ecx;
	push edx;
	asm
}
inline qs_fora (int32_a f, int32_a count)
{
	asm
    xor ecx, ecx;
	mov edx, [count];
    f:;
	push ecx;
	push edx;
	asm
}

inline qs_endfor (int32_a f)
{
	asm
	pop edx;
	pop ecx;
    inc ecx;
    cmp ecx, edx;
    jl f;
	asm
}
inline qs_cin (int32 cinvar)
{
	asm
	lea eax, [cinvar];
	push eax;
	push varFormat;
	call [scanf];
	add esp, 8;
	asm
}
inline Point.create (int32 point, int32 x, int32 y)
{
	asm
	mov eax, x;
	mov [point + Point.x], eax;
	mov eax, y;
	mov [point + Point.y], eax;
	asm
}
void hello_print(int32 it)
{
	qs_printf("HELLO:"); qs_printva(it); qs_endl();
}
void cycle (int32 iterc)
{
	int32 count = 1;

	iter (iterc)
	{
		hello_print(count);
		count += 1;
	}
}
//stucts
struct Point
{
public:
	int32 x;
	int32 y;
}
struct Points
{
public:
	Point p1;
	Point p2;
}

struct HeapPoolStruct
{
public:
	int32 poolPtr;
}

//start code

qs_gethConsole();

HeapPoolStruct heapPool?;
heapPool.poolPtr = 323232;
qs_printf("heapPool.poolPtr = {"); qs_printva(heapPool.poolPtr); qs_printfl("}");

cycle(40);

Points pss?;
Point.create(pss.p1, 0, 0);
Point.create(pss.p2, 0, 0);

pss.p2.x += 12;
pss.p1.x += 24;
pss.p2.y = pss.p2.x + pss.p1.x;
pss.p1.y = pss.p2.y - pss.p1.x;
//p1.x = 20;
//p1.y = 10;
//p2.x = 25;
//p2.y = 15;

qs_printf("P2 x:"); qs_printva(pss.p2.x); qs_endl();
qs_printf("P2 y:"); qs_printva(pss.p2.y); qs_endl();

qs_endl();

qs_printf("P1 x:"); qs_printva(pss.p1.x); qs_endl();
qs_printf("P1 y:"); qs_printva(pss.p1.y); qs_endl();

qs_endl(); qs_endl();

//qs_getch();

// 12 >= 12  12 < 12 false

//int32 output = 32;
//cin(output);
//qs_getch();
inline fibm ()
{
	asm
	mov eax, 0;
	cmp [n], eax;
	jne false1;
	ret;
	false1:;
	dec [n];
	asm
}
void fib()
{  
    //fibm(n);
    //n = fib(n - 1) + fib(n - 2)
	//ntemp = n - 1;
	//n1 = fib(ntemp);
	//ntemp = n - 2;
	//n2 = fib(ntemp);
	//n = n1 + n2;
	qs_printva(n); qs_endl();
	fibm();
	fib();

}

//int32 n = 10;
//int32 n1;
//int32 n2;
//int32 ntemp;
//fib();

//qs_printf("Output: "); qs_printva(output); qs_endl();
	
//qs_getch();

inline lpMi (){
	asm
	lpM:;
	asm
}
inline lpJmp (){
	asm
	jmp lpM;
	asm
}
void calculator (int32 n)
{
	int32 a;
	int32 b;
	int32 r;

	lpMi();
	qs_printf("First Number: ");
	qs_cin(a);
	qs_endl();
	qs_printf("Second Number: ");
	qs_cin(b);

	r = a + b + n;
	qs_printf("Resualt: "); qs_printva(r); qs_endl();
	if (r < 999)
	{
		qs_getch();
		lpJmp();
	}
}


//int32 n = 0;
//calculator(n);

void program2 ()
{
	int32 age;
	qs_cin(age);
	
	if (age <= 7)
	{
		qs_printfl("DO SHOOCLDREN!");
	}
	if (age > 7 || age < 14)
	{
		qs_printfl("CHILDREN!");
	}
	if (age >= 14 && age < 18)
	{
		qs_printfl("TENAGER!");
	}
	if (age >= 18)
	{
		qs_printfl("VERY AGE!");
	}
}

void program3 ()
{
	int32 c_count = 1;
	iter (10000)
	{
		qs_printf("ITER: "); qs_printva(c_count); qs_endl();
		c_count += 1;
	}
}

void program4 ()
{
	//int32 c_count = 1;
	//iter (100)
	//{
		//qs_printf("ITER: "); qs_printva(c_count); qs_endl();
		//c_count = c_count * 2 + c_count / 2;
	//}
	//resualt = c_count;
}

program2();
//program3();

int32 resualt;
//program4();
qs_printf("ITER: "); qs_printva(resualt); qs_endl();


float ddf = 14.5f;


int32 nm1 = 12;
int32 nm2 = 12;
int32 nm3;
nm3 = nm1 + nm2;


float fl1 = 1.25f;
float fl2 = 1.25f;
float fl3;

fl3 = fl1 + fl2;
qs_printf("fl3 : "); qs_printvaf(fl3); qs_endl(); 


int32 input2 = 0;
//ddf += 14.23f + 23f * 12f - 3.12f - 0.23;
qs_printvaf(ddf);


Point get_point (Point pt)
{
	return pt;
}

int32 get_int32 (int32 a)
{
	if (a < 10)
	{
		return a;
	}
	else
	{
		return a+30;
	}
}

int32 fff;
int32 fff2;


int32 fibn;

int32 fibonacci (int32 nnn)
{
	//int32 fibn1;
	//int32 fibn2;
    if (nnn == 0 || nnn == 1)
	{
		return nnn;
	}
    else 
	{
		//fibn1 = fibonacci(nnn - 1);
		//fibn2 = fibonacci(nnn - 2);
		//fibn = fibn1 + fibn2;
		return fibonacci(nnn - 1) + fibonacci(nnn - 2);
	}
}

qs_endl();qs_endl();qs_endl();

fibn = fibonacci(16);
qs_printf("Fibonacci: "); qs_printva(fibn);

qs_getch();
qs_endl(); qs_endl();

iter (10)
{
	qs_cin(fff2);
	fff = get_int32(fff2);
	qs_printf("FFF: "); qs_printva(fff); qs_endl();
}

Point testPtN?;
testPtN.x = 12;
testPtN.y = 12;
Point testPt?;
testPt = get_point(testPtN);

testPt.x += 32;

qs_endl();
qs_printf("testPt.x = "); qs_printva(testPt.x); qs_endl();
qs_printf("testPt.y = "); qs_printva(testPt.y); qs_endl();
qs_endl();

qs_printfl("testPt.x");

qs_getch();

iter (10)
{
	qs_cin(input2);
	ddf = input2 + 10f;
	if (ddf > 10f && ddf < 20f)
	{
		qs_printfl("ddf > 10f && ddf < 20f:"); qs_printvaf(ddf); qs_endl();
	}
	else-if (ddf > 20f && ddf < 30f)
	{
		qs_printfl("ddf > 20f && ddf < 30f:"); qs_printvaf(ddf); qs_endl();
	}
	else-if (ddf > 30f && ddf < 40f)
	{
		qs_printfl("ddf > 30f && ddf < 40f:"); qs_printvaf(ddf); qs_endl();
	}
	else-if (ddf > 40f && ddf < 50f)
	{
		qs_printfl("ddf > 40f && ddf < 50f:"); qs_printvaf(ddf); qs_endl();
	}
	else-if (ddf > 100f && ddf < 200f)
	{
		qs_printfl("ddf > 100f && ddf < 200f:"); qs_printvaf(ddf); qs_endl();
	} else-if (ddf > 100f || ddf < 300f)
	{
		qs_printfl("ddf > 100f || ddf < 300f:"); qs_printvaf(ddf); qs_endl();
	}
}


qs_getch();


int32 input;

iter (10)
{
	qs_cin(input);
	if (input == 12)
	{
		qs_printfl("1 if input == 12!!!");
	} else-if (input < 12)
	{
		qs_printfl("2 else if input < 12!!!");
	} else
	{
		qs_printfl("3 else !!!");
	}
}


//qs_printfl("ITER End");

//int32 test1 = 10;
//test1 *= 3;
//qs_printva(test1);

qs_getch();

//end
// data
asm
section '.data' data readable writable;
    varFormat db '%d', 0;
    strFormat db '%s', 0;
	floatFormat db '%f', 0;
	hello db 'Hello World!', 0;
	endl db 10, 13, '', 0;
	tptr dd 0;
	STD_OUTPUT_HANDLE = -11;
	hConsole dd 0;
	qs.buffer dd 0;
asm
// import
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
                WriteConsoleA, 'WriteConsoleA';
            import msvcrt,\;
                printf, 'printf',\;
                getch, '_getch',\;
                scanf, 'scanf';
            import user,\;
                MessageBox, 'MessageBoxA';
asm