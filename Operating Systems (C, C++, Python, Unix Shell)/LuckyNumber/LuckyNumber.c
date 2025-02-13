#include "stdio.h"
#include "time.h"
#include "LuckyNumber.h"

int checkLuckyNumber(int guess)
{
	srand(time(NULL));

	int goal = rand()%5+1;
	printf("goal is %d", goal);

	if (guess == goal)
	{
		return 0;
	}
	else if (guess < goal)
	{
		return -1;
	}
	else
	{
		return 1;
	}
}