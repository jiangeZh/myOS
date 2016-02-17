#include "process.h"

int bankbalance=1000;/*银行帐户余额1000元*/

main() {
	int pid,sem_id;
	int i=15;
	int totalsave=0,totaldraw=0;
	sem_id = getSem(1);
	pid=fork();
	if (pid == -1) {printf("error in fork!");exit(-1);}
	if (pid)
	{
        	while (i--)  
		{
             		p(sem_id);
             		bankbalance += 15;          ;/*父进程反复存钱，每次15元*/
			delay(3); 
             		totalsave += 15;
			delay(2); 
             		printf("bankbalance=%d, totalsave=%d\n\r",bankbalance,totalsave);
             		v(sem_id);
		}
         	exit(0);
	} 
	else 
	{
              /*子进程反复取钱，每次20元*/		
        	while (i--)
		{
             		p(sem_id);
			delay(1);
             		bankbalance -= 5;
             		totaldraw += 5;
             		printf("bankbalance=%d, totaldraw=%d\n\r",bankbalance,totaldraw);
             		v(sem_id);
		}
   		exit(0);
	}
}