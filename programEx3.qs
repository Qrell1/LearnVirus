include "qsr.qh";


qsr.init(16777216) // 1 kb

Random rand?

//Array @int32 array3 = Array.init @int32 (10)
//int32* array3 = malloc (typeof.int32 * 10)
Array @int32 array = Array.init @int32 (10)

enumerator int32 index, 10
{
    array.Items[index] = rand.next(10, 100)
}

enumerator int32 index2, 10
{
    printq @int32 (array.Items[index2])
    printq @string (" | ")
}


int32 fib (int32 nnn, int32 memo)
{
    if (memo[nnn] != 0) return memo[nnn]
	if (nnn <= 1) { return nnn; }
	else
	{
		int32 resualt = fib(nnn- 1, memo) + fib(nnn- 2, memo)
        memo[nnn] = resualt
        return resualt
    }
}

int32 fib2 (int32 ns, Array @int32 memo2)
{
    if (memo2.Items[ns] != 0) 
    {
        int rss = memo2.Items[ns]
        return rss
    }
	if (ns <= 1) { return ns }
	else
	{
		int32 resualt2 = fib2(ns- 1, memo2) + fib2(ns- 2, memo2)
        memo2.Items[ns] = resualt2
        return resualt2
    }
}

StopWatcher sw?

sw.Start()
Array @int32 memoarray?
memoarray.Items = malloc (typeof.int32 * 10)
//int32 fibn = fib(36, memoarray.Items)
int32 fibn = fib2(36, memoarray)
sw.Stop()

Console.endl()
printq @string ("Fibn = ") printq @int32(fibn) Console.endl()
printq @string ("Total = ") printq @int32(sw.Total)

printq @string ("TEST")
printf ("Resualt: %d", rand.next(10, 100))
Console.endl() Console.endl()

/*struct ListNode @T
{
    ListNode @T leftNode
    ListNode @T rightNode
    T value
    int32 Number
}

class List @T
{
    ListNode @T Node
    int32 Count
    int32 Memory
    int32 ItemSize
    ListNode @T temp
    
    void init ()
    {
        this.ItemSize = sizeof.this.temp
        this.Node = malloc(sizeof.this.temp)
    }
    
    void add (T value)
    {
        Count += 1
        ListNode @T newNode = malloc(sizeof.this.temp)
        newNode.leftNode = &this.Node
        newNode.Number = Count
        this.Node.rightNode = &newNode
        this.Node = &newNode
    }
}*/

struct ListNode
{
    ListNode_int* leftNode
    ListNode_int* rightNode
    int32 value
    int32 Number
}
class List_int
{
    ListNode_int* Node
    int32 Count
    int32 Memory
    int32 ItemSize
    ListNode_int temp
    
    void init ()
    {
        this.ItemSize = sizeof.this.temp
        this.Node = malloc(16)
    }
    
    void add (int32 value)
    {
        this.Count += 1
        ListNode_int* newNode = malloc(16)
        newNode.leftNode = this.Node
        newNode.Number = Count
        this.Node.rightNode = newNode
        this.Node = newNode
    }
}
List_int list?
list.init()

//List @int32 list?

list.add(12)
list.add(42)
list.add(34)

class Box @T
{
    T value
    void initValue () { this.value = new @T () }
    T getValue () { return this.value }
}

/*
Box @int32 boxInt32 = new @Box @int32 ()
boxInt32.initValue()
boxInt32.value = 222
printq @int32 (boxInt32.getValue())
boxInt32.value -= 111
printq @int32 (boxInt32.getValue())

Box @Box @int32 boxs = new @Box @Box @int32 ()
boxs.initValue()
boxs.value = boxInt32
printq @int32 (boxs.value.getValue())
*/


Console.endl()
Console.getch()
