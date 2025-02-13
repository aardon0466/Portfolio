#include <stdio.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

class Process
{
	public:
	 string name;
	 int burst;
	 int arrival;
	 bool active
	 bool complete;
	 char status[50];
	 
	Process()
	{
		for(int i = 0; i < 50; i++)
		{
			status[i] = ' ';
		}
	}

	void setStatus(int time)
	{
		if(active && burst > 0)
		{
			status[time] = '#';
		}
		else if(!active && arrival > time && !complete)
		{
			status[time] = '_';
		}
	}
	
	bool operator<(Process const &other) {return burst < other.burst;}	

};

void parseFile(Process* procs)
{
	string inStrings[10];
	fstream input("test.txt");
	int i = 0, j;
	
	while(getline(input, inStrings[i]))
	{
		i++;
	}
	
	for(i = 0; i < 4; i++)
	{
		stringstream ss(inStrings[i]);
		ss >> procs[i].name;
		ss >> procs[i].burst;
		ss >> procs[i].arrival;
		procs[i].active = false;
		procs[i].complete = false;
	}
}

void printProcesses(vector<Process> procs)
{
	int i, j;
	int throughput = 0;
	double wait = 0;
	double response = 0;
	bool started = false, completed = false;
	
	for(i = 0; i < 4; i++)
	{
		cout << procs.at(i).name << " ";
		printf("\t%s\n", procs.at(i).status);
		
		for(j = 0; j < 50; j++)
		{
			if(procs.at(i).status[j] == '_' && !started)
			{
				wait++;
				response++;
			}
			else if(procs.at(i).status[j] == '_')
			{
				wait++;
			}
			else if(procs.at(i).status[j] == '#')
			{
				started = true;
			}
			else if(procs.at(i).status[j] == ' ' && started && !complete && j < 10)
			{
				throughput++;
				completed = true;
			}
		}
		
		completed = false;
		started = false;
	}
	
	cout << "Average wait time: " << wait/4 << endl;
	cout << "Average response time: " << response/4 << endl;
	cout << "Thoughput over 10 cycles: " << throughput << endl;
}

void FIFO(Process* procs)
{
	int i, j;
	int front = 0;
	vector<Process> ready;
	bool started = false;
	
	for(i = 0; i < 23; i++)
	{
		for(j = 0; j < 4; j++)
		{
			if(procs[j].arrival == i)
			{
				ready.push_back(procs[j]);
				
				if(!started)
				{
					ready.at(front).active = true;
					started = true;
				}
			}
		}
		
		if(ready.at(front).burst == 0)
		{
			ready.at(front).active = false;
			ready.at(front).complete = true;
			front++;
			ready.at(front).active = true;
		}
		else
		{
			ready.at(front).burst--;
		}
		
		for(j = 0; j < ready.size(); j++)
		{
			ready.at(j).setStatus(i);
		}
	}
	
	printProcesses(ready);
}

void SJF(Process* procs)
{
	int i, j;
	int front = 0;
	vector<Process> ready;
	bool started = false;
	
	for(i = 0; i < 23; i++)
	{
		for(j = 0; j < ready.size(); j++)
		{
			ready.at(j).setStatus(i);
		}
		
		for(j = 0; j < 4; j++)
		{
			if(procs[j].arrival == i)
			{
				if(started)
				{
					ready.at(front).active == false;
				}
				
				started = true;
				ready.push_back(procs[j]);
				sort(ready.begin(), ready.end());
				ready.at(front).active = true;
			}
		}
		
		if(ready.at(front).burst == 0)
		{
			ready.at(front).active = false;
			ready.at(front).complete = true;
			front++;
			ready.at(front).active = true;
		}
		else
		{
			ready.at(front).burst--;
		}
	}
	
	printProcesses(ready);
}

void RoundRobin(Process* procs)
{
	int i, j;
	int front = 0;
	int loop = 0;
	vector<Process> ready;
	bool started = false;
	
	for(i = 0; i < 23; i++)
	{
		for(j = 0; j < ready.size(); j++)
		{
			ready.at(front).active = true;
			ready.at(j).setStatus(i);
		}
		
		for(j = 0; j < 4; j++)
		{
			if(procs[j].arrival == i)
			{
				ready.push_back(procs[j]);
			}
		}
		
		ready.at(front).burst--;
		
		if(ready.at(front).burst == 0)
		{
			ready.at(front).complete = true;
		}
		
		for(j = 0; j < ready.size(); j++)
		{
			ready.at(front).active = false;
			front++;
			if(front >= ready.size())
			{
				front = 0;
			}
			
			if(!ready.at(front).complete)
			{
				break;
			}
			
			loop++;
			
			if(loop >= 4)
			{
				printProcesses(ready);
				return;
			}
		}
		
		loop = 0;
	}
}

int main(void)
{
	Process procs[5];
	
	parseFile(procs);
	
	cout << "FIFO Algorithm: " << endl;
	FIFO(procs);
	
	cout << "\nSJF Algorithm: " << endl;
	SJF(procs);
	
	cout << "\nRound Robin Algorithm: " << endl;
	RoundRobin(procs);
	
	return 0;
}