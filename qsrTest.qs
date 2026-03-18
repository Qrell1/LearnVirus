include "qsr.qh";
//include "opengl.qh";
//include "file.qh";

//Int32 PoolSegment2 = 1024;       // 1024 bat
int32 PoolSegments2 = 1024 * 1536 // 96 mbat

//Qsr qsr?;
qsr.init(PoolSegments2)


//Window window?// = new @Window()

//window.Create(400, 600, "ClassName", "My QsriptNt Window")

//OpenGlContext openglContext?
//openglContext.InitOpenGl(window.hWindow, 400, 600)
//openglContext.Clear(0.12f, 0.12f, 0.12f)
//openglContext.SwapBuffers()
//glClearColor(1f, 1f, 0f, 1f)
float f1 = 1f
float f2 = 0f
//asm
//mov eax, [f1]
//push eax
//push eax
//push eax
//mov eax, [f2]
//push eax
//call [glClearColor]
//asm
//openglContext.Clear()

//printq @string ("Window Name : ") printq @string (window.lpszMenuName)
//Console.endl()
Random randObj?

iter 1000
{
	int32 rand = randObj.next(1, 100) 
	printq @string ("Random: ") printq @int32 (rand)
	Console.endl()
}

printf ("Hello String:%s Number:%d", "Str", 100)

//Window window2 = new @Window ()
//window2.Create(256, 256, "ClassName", "Second Window")


asm
//msg_loop:
    //invoke GetMessageA, msg, 0, 0, 0
    //cmp eax, 0
    //je end_loop
    //invoke TranslateMessage, msg
    //invoke DispatchMessageA, msg
    //jmp msg_loop
//end_loop:
asm
//CreateDirectory("C:\\FILECREATETEST\\")

PrintSystemTime()
int32 sum = SumSystemTime()
Console.endl()
printq @string ("SumSystemTime: ") printq @int32 (sum)
Console.endl()

int32 key
Console.cin(key)

if (key != 123456)
{
	qsr.exit(0)
}

//Init();
//CreateWindow(600, 400);Window window?


int32 ptrQ = malloc(8)
int32 ptr2Q = malloc(8)


qsr.PoolPrint()

//mfree(ptrQ);

//Console.WriteLine("%s", "QSR qh TEST");
Console.WriteLine("%s", "Testing Second...")

Console.WriteLine("%s", "Testing First...")
Console.Write("%d", 999)
printq<int32>(12121)

Console.endl()


int32 fib (int32 nnn)
{
	if (nnn <= 1) { return nnn; }
	else
	{
		return fib(nnn- 1) + fib(nnn- 2)
    }
}

int32 tick
tick = qsr.getTick()

StopWatcher* sw = new @StopWatcher ()
//StartStopWatcher(sw)
sw.Start() 

int32 fibn
fibn = fib(36)

//StopStopWatcher(sw)
sw.Stop()

int32 tick2
tick2 = qsr.getTick()
tick = tick2 - tick

printq @int8 ("Fibonacci Tick: ") printq<int32>(sw.Total)
printq @int8 ("Fibonacci Number: ") printq<int32>(fibn)


struct Point2D_
{
	int32 x
	int32 y
}

//Point2D* ps = malloc(8);
//Point2D ps = malloc(8);

Point2D_* ps1 = malloc(8)
ps1.x = 12
ps1.y = 24
void printPoint (Point2D_ ps)
{
	printq<string>("Point.X = ") printq<int32>(ps.x); Console.endl()
	printq<string>("Point.Y = ") printq<int32>(ps.y); Console.endl()
}
void printVector2i (Vector2i_ vc)
{
	printq<string>("Vector.X = ") printq<int32>(vc.x); Console.endl()
	printq<string>("Vector.Y = ") printq<int32>(vc.y); Console.endl()
}
void printVectorDec (VectorDec<T, Q> vc) <T, Q>
{
	printq<string>("VectorDec.X = ") printq<int32>(vc.x); Console.endl()
	printq<string>("VectorDec.Y = ") printq<int32>(vc.y); Console.endl()
}

struct VectorDec @T, @Q
{
	T x
	Q y
}

//VectorDec @int32, @int32 psdec ?;
VectorDec @int32, @int32 psdec = malloc(8)
psdec.x = 5655
psdec.y = 6565
printVectorDec @int32, @int32 (psdec)

printPoint (ps1)
ps1.y = ps1.x + ps1.y
printPoint (ps1)

Point2D_* ps2 = malloc(8)
//mcopy(&ps1, &ps2, 8);
//mcopy(&ps1, &ps2, typeof.Point2D);
//copy @Point2D (ps1, ps2)
copy @Point2D_ (ps1, ps2)
printPoint (ps2)

struct Vector2i_ { int32 x int32 y }

//Vector2i* vc1 = malloc(8);
//Vector2i vc1?;
Vector2i_ vc1 = new @Vector2i_ ()
//vc1 = new @Vector2i();



vc1.x = 3232 % 15
vc1.y = 3232 % 15
printVector2i(vc1)

//int32* array = malloc(typeof.int32 * 10);
//int32* array = Array.init<int32>(10);
Array @int32 array = Array.init @int32 (10)
//Array<int32> array = Array.init<int32>(10);
// Ну и так тож можно Array @Array @int32 array = Array.init @Array @int32 (10);
// Ну и так Dic @Array @int32 , @int32 keywords;

Vector2i_* vectorArray = malloc(typeof.Vector2i_ * 10)
Vector2i_ tempVector?

enumerator int32 ei, 10
{
	array.Items[ei] = ei * 10
	//tempVector.x = ei * 32;
	//tempVector.y = ei * 16;
	//vectorArray[ei] = tempVector;
	//vectorArray[ei] = ei * 32;
	//vectorArray[ei] = ei * 16;
	vectorArray[ei] = 12
	vectorArray[ei] = 32
}


enumerator int32 ei2, 10
{
	printq<int32>(ei2); printq<string>(" : ")
	printq<int32>(array.Items[ei2])
	Console.endl()
	printVector2i(vectorArray[ei2])
	Console.endl()
}

qsr.PoolPrint()

Console.getch()
//qsr.exit(0)


class Program {

    Program ()
	{}

    //~Program ()
	//{}

    void Main ()
	{}

    void MyFunc() {}
}


int32 rn1 = random(0, 100, 1)

Console.endl()
printq @string ("Random: ") printq @int32 (rn1)

//SystemTime sTime?
//GetSystemTime(&sTime)


Console.endl()
//int32 timeOut = ConvertToInt32 @int16 (sTime.wHour);
//printq @string ("wYear: ")         printq @int32 (sTime.Year)        Console.endl()
//printq @string ("wMonth: ")        printq @int32 (sTime.Month)       Console.endl()
//printq @string ("wDayOfWeek: ")    printq @int32 (sTime.DayOfWeek)   Console.endl()
//printq @string ("wDay: ")          printq @int32 (sTime.Day)         Console.endl()
//printq @string ("wHour: ")         printq @int32 (sTime.Hour)        Console.endl()
//printq @string ("wMinute: ")       printq @int32 (sTime.Minute)      Console.endl()
//printq @string ("wSecond: ")       printq @int32 (sTime.Second)      Console.endl()
//printq @string ("wMilliseconds: ") printq @int32 (sTime.Milliseconds)Console.endl()

//	int16 wYear
//	int16 wMonth		
//	int16 wDayOfWeek		 
//	int16 wDay
//	int16 wHour
//	int16 wMinute
//	int16 wSecond
//	int16 wMilliseconds

Console.getch()
