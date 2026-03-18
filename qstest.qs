using "qsruntime.qsr";

//using qs_printva inline;
//using qs_printf inline;
//using qs_printv inline;
//using qs_endl inline;
//using qs_getch inline;

using {
	qs_printva, qs_printf,
	qs_printv, qs_endl,
	qs_getch
} inline;


int32 count = 10;

count = count + 12;

count -= 1;
qs_printva(count); qs_endl();
count -= 1;
qs_printva(count); qs_endl();
count -= 1;
qs_printva(count); qs_endl();


struct Array <T>
{
	int32 Items;
	int32 Count;
	int32 ItemSize;
}
inline Array.init(int32 list, int32 len, int32 size)
{
	asm
	mov [list + Array_int32.Items], esp;
	mov eax, size;
	mov ebx, len;
	imul eax, ebx;
	sub esp, eax;
	mov eax, len;
	mov [list + Array_int32.Count], eax;
	mov [list + Array_int32.ItemSize], size;
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

struct Pt { int32 tag; }
struct Point { Pt tag; }

Point tagPoint?;

Array<int32> list?;
Array.init(list, 10, 4);

list.Items[2] = 222;
list.Items[1] = 122;

int32 index1 = list.Items[1];
int32 index2 = list.Items[2];

qs_printf("Items[1] = "); qs_printva(index1); qs_endl();
qs_printf("Items[2] = "); qs_printva(index2); qs_endl();


Array<int32> numbers?;
Array.init(numbers, 100, 4);

int32 i = 0;
//numbers.Items[i] = i; i += 1;
//numbers.Items[i] = i; i += 1;
//numbers.Items[i] = i; i += 1;
//numbers.Items[i] = i;
qs_printf("List.Items = "); qs_printva(numbers.Items); qs_endl();
qs_printf("List.Count = "); qs_printva(numbers.Count); qs_endl();
qs_printf("List.ItemSize = "); qs_printva(numbers.ItemSize); qs_endl();
iter (40) {
    numbers.Items[i] = i;
	i += 1;
}

qs_printf("List.Items = "); qs_printva(numbers.Items); qs_endl();
qs_printf("List.Count = "); qs_printva(numbers.Count); qs_endl();
qs_printf("List.ItemSize = "); qs_printva(numbers.ItemSize); qs_endl();

int32 sum = 0;
int32 sumn;
int32 j = 0;
qs_printf("ITER: ");
iter (4) {
    sumn = numbers.Items[j];
	sum += sumn;
	j += 1;
	qs_printv(eax); qs_endl();
	qs_printva(j); qs_endl();
	//qs_printva(j);
}
qs_endl();

int32 num;
num = numbers.Items[0];
qs_printf("num0 = "); qs_printva(num); qs_endl();
num = numbers.Items[1];
qs_printf("num1 = "); qs_printva(num); qs_endl();
num = numbers.Items[2];
qs_printf("num2 = "); qs_printva(num); qs_endl();

// 0 | 
// 1 | 
// 2 | 

qs_printf("sum = "); qs_printva(sum); qs_endl();

iter (10)
{
	qs_printf(hello); qs_endl();
	qs_printv(43+23); qs_endl();
}

qs_getch();