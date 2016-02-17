#include "process.h"
char str[80]="129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr=0;

void main() 
{
   	int pid = 0;
	int pid2 = 0;
	printf("Begin...\n\r");
	pid=fork();
	if (pid == -1) printf("error in fork!");
	if (pid)  
	{   
		printf("Pro1 is waiting...\n\r");
		wait();
		printf("Pro1 is wakeup\n\r");
		printf("LetterNr=%d\n\r", LetterNr);  
	} 
	else 
	{   
		Upper(str);
		printf("Upper_str=%s\n\r", str);
		pid2 = fork();
		if (pid2 == -1) printf("error in fork2!");
		if (pid2)
		{
			printf("Pro2 is waiting...\n\r");
			wait();
			printf("Pro2 is wakeup\n\r");
			exit(0);
		}
		else
		{
			printf("Pro3 is counting...\n\r");
			LetterNr = CountLetter(str); 
			exit(0);
		}
	}
	printf("Success!\n\r");
}
