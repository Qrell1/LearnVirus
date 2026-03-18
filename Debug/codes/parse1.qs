// Просто скрипт для дебага построения аст
int32 parse = (5*5+5);
parse -= 5;
parse = parse - 5;
parse = (5*5*parse)/2;

// LEVEL 1
// Тест функций их сигнатур и так скажим областей имён
int16 yy12 (int32 num1, int16 num2);
yy12((5+1),5*2);
sf.parse = 12;
sf.test.fg.as.yt(32,(5454+64/43));

//int32 CONST = 12+12;
// LEVEL 2
// Тест супер вложеных формул
int32 test1 (int32 num);
int32 test2 = ((test1(12)+test1(32))/2*4+reftest.ref2.var-reftest.ref2.ref3.var)*2;


// LEVEL 3
// Тест тел функций
int32 sub (int32 num1, int32 num2)
{
	int32 num = num1+num2;
	//Токен return ещё не обрабатывается в парсере по этому не пишу
}

// LEVEL 3
// Тест тел функций
int32 sub (int32 num1, int32 num2)
{
	int32 num = num1+num2;
	//Токен return ещё не обрабатывается в парсере по этому не пишу
}

// LEVEL 4
if (r1 == r1)
{
	sub(1,1);
} else-if ((r1+r1) != 3 && ((r1/r1)+5) || 4 == 3)
{
	sub(1,1);
} 