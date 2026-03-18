include "qsr.qh";

// Сначала нужно объявить всё нужное

qsr.init(1024)

Random rand = new @Random ()
int number
int input
int attempt

// Основной Цикл
iter 100
{
	winTag:
    number = rand.next(1, 100)
	printq @string ("10 attempts to select a number(1-100)!") Console.endl()
	attempt = 10

    iter 10
	{
        printq @string ("Input Number: ")
        Console.cin(input)
	
        if input < number
	    {
			printq @string ("Your input < number") Console.endl() 
		}
		if input > number
		{
			printq @string ("Your input > number") Console.endl() 	
		}
		if input == number
		{
			printq @string ("You win!") Console.endl()
			jump winTag
		}
	}
	printq @string ("You defeat!") Console.endl()
}
