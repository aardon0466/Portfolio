#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>

// Prints the message of the day
void motd()
{
	printf("\x1b[36m" "\n***** Message of the Day *****\n");
	printf("   Have a wonderful day =)\n");
	printf("******************************");
}

// Prints the current directory
void currentDir()
{
	char cwd[1024];
	getcwd(cwd, sizeof(cwd));
	printf("\x1b[34m");
	printf("%s> ", cwd);
	printf("\x1b[37m");
}

// Parse the input string from user
void parseString(char* input, char** parsed)
{
	int i;
	
	for(i = 0; i < 100; i++)
	{
		parsed[i] = strsep(&input, " ");
		
		if(parsed[i] == NULL)
		{
			break;
		}
		if(strlen(parsed[i]) == 0)
		{
			i--;
		}
	}
}

// Determine how the user command is handled
int cmdHandling(char** parsed)
{
	int i;
	int cmdNum = 2, cmdSwitch = 0;
	char* cmds[cmdNum];
	
	cmd[0] = "exit";
	cmd[1] = "cd";
	
	for(i = 0; i < cmdNum; i++)
	{
		if(strcmp(parsed[0], cmds[i]) == 0)
		{
			cmdSwitch = i + 1;
		}
	}
	
	switch (cmdSwitch)
	{
	case 1:
		printf("\x1b[32m" "Exiting...\n\n");
		printf("\1xb[37m");
		exit(0);
	case 2:
		chdir(parsed[1]);
		return 1;
	default:
		break;
	}
	
	return 0;
}

// Executes the user's command
void execCmds(char** parsed)
{
	printf("\x1b[32m" "\n----------Program Started----------\n" "\x1b[37m");
	pid_t pid = fork();

	if(pid == -1)
	{
		printf("\x1b[31m" "\nFailed fork\n");
		return;
	}
	else if(pid == 0)
	{
		if(execvp(parsed[0], parsed) < 0)
		{
			printf("\x1b[31m" "\nCould not execute\n");
		}
		exit(0);
	}
	else
	{
		waitpid(NULL);
		printf("\x1b[32m" "\n-----------Program Ended-----------\n" "\x1b[37m");
	}	return;
}

int main(void)
{
	int shouldRun = 1, changeDir;
	char input[1000], *parsed[100];
	
	motd();
	
	while(shouldRun)
	{
		currentDir();
		fgets(input, 1000, stdin);
		strtok(input, "\n");
		parseString(input, parsed);
		changeDir = cmdHandling(parsed);
		
		if(changeDir == 0)
		{
			execCmds(parsed);
		}
	}
	
	return 0;
}