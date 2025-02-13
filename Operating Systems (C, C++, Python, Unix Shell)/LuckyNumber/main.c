#include "stdio.h"
#include "time.h"
#include "LuckyNumber.h"
#include "Record.h"

void main() 
{
	char repeat = 'y';
	int guess;

	struct Record r = {0, 0, 0};

	while (repeat == 'y')
	{
		printf("Please enter your guess: ");
		scanf("%d", &guess);

		int check = checkLuckyNumber(guess);

		if (check == 0)
		{
			r.wins = r.wins + 1;
		}
		else if (check < 0) 
		{
			r.less = r.less + 1;
		}
		else 
		{
			r.more = r.more + 1;
		}

		printf("\nWins: %d\nMore: %d\nLess: %d\n", r.wins, r.more, r.less);

		printf("\nPlay again? (y/n): ");
		scanf(" %c", &repeat);
	}
}