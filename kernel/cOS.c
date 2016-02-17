extern void cls();
extern void getch(char *ch);
extern void putch(char ch);
extern void gets(char str[]);
extern void printf(char * info,int pos,int size);
extern void do1();
extern void do2();
extern void do3();
extern void do4();
extern void do5();
extern void do6();
extern void do7();
extern void do8();
extern void do9();
extern void time();

#include "kdata.h"

int disp_pos=0;
char str1[11] = "MY-OS 2.0\n";
char str2[24] = "(C) 2015 Zhang Huajian\n";
char str3[42] = "Please key in a program execution order:\n";
char str4[18] = "The end, thanks!\n";
char command[30];
char ret;
char order[9];
int buffer1 = 0;
int j = 0;
int k = 0;

cDisplay()
{
	disp_pos = 0;
	buffer1 = 0;
	j = 0;
	k = 0;
	cls();
	printf(str1,0x0724,10);
	printf(str2,0x091e,23);
	putch('\r');	
	mygets(command);
	if (equal(command, "date") == 1)
	{
		cls();
		printf("Today is ",0x0c14,9);
		time();
		printf("Press any key to return...",0x0d14,26);
		getch(&ret);
		return;		
	}
	
	else if (equal(command, "run") == 1)
	{
		cDo();
		return;
	}
	else if (equal(command, "para") == 1)
	{
		parallelDo();
		return;
	}
	else
	{
		cls();
		printf("Error:Illegal instruction\n",0x0a14,26);
		printf("Press any key to return...",0x0b14,26);
		getch(&ret);
		return;
	}
}



int equal(char info[], const char* info2)
{
	
	while (info[k] != '\0' && info2[k] != '\0')
	{
		if (info[k] != info2[k]) 
		{
			k = 0;
			return 0;
		}
		k++;
	}
	if (info[k] == '\0' && info2[k] != '\0')
		return 0;
	else if (info[k] != '\0' && info2[k] == '\0')
		return 0;
	else	
		return 1;
}

cDo()
{
	printf(str3,0x0b14,41);
	while (buffer1 < 9)
	{	
		getch(&order[buffer1]);
		if (order[buffer1] == '1' || order[buffer1] == '2' || order[buffer1] == '3' || order[buffer1] == '4'|| order[buffer1] == '5'|| order[buffer1] == '6'|| order[buffer1] == '7'|| order[buffer1] == '8' || order[buffer1] == '9')
		{
			putch(order[buffer1]);
			buffer1++;	
		}
		else if (order[buffer1] == '\r') break;
	}

	for (; j < buffer1; j++)
	{
		if (order[j] == '1')
		{
			cls();
			load(0x1000,1,12);
			do1();
		}
		
		else if (order[j] == '2')
		{
			cls();
			load(0x2000,1,13);
			do2();
		}
		else if (order[j] == '3')
		{
			cls();
			load(0x3000,1,14);
			do3();
		}
		else if (order[j] == '4')
		{
			cls();
			load(0x4000,1,15);
			do4();
		}
		else if (order[j] == '5')
		{
			cls();
			load(0x5000,1,16);
			do5();
		}
		else if (order[j] == '6')
		{
			cls();
			load(0x6000,2,17);
			do6();
		}
		else if (order[j] == '7')
		{
			cls();
			load(0x7000,1,19);
			do7();
		}
		else if (order[j] == '8')
		{
			cls();
			load(0x8000,1,20);
			do8();
		}
		else if (order[j] == '9')
		{
			cls();
			freeAll();
			Program_Num = 1;
			CurrentPCBno = 1;
			load(0x9000,2,21);
			init(&pcb_list[0],0,0x7e00);
			init(&pcb_list[1],0x9000,0x100);
			setClock();
			do9();
			Program_Num = 0;
		}
	}
	cls();
	printf(str4,0x0a20,17);
	printf("Press any key to return...",0x0c15,26);
	buffer1 = 0;
	getch(&ret);
	return;
}


initPro()
{
	load(0x2000,1,13);
	load(0x3000,1,14);
	load(0x7000,1,19);
	load(0x8000,1,20);
	init(&pcb_list[0],0,0x7e00);
	init(&pcb_list[1],0x2000,0x100);
	init(&pcb_list[2],0x3000,0x100);
	init(&pcb_list[3],0x7000,0x100);
	init(&pcb_list[4],0x8000,0x100);
}


parallelDo()
{
	cls();
	Program_Num = 4;
	CurrentPCBno = 1;
	freeAll();
	initPro();
	setClock();
	do2();
}



intToStr(int x,char str[])
{
	int i = 0;
	int j = 0;
	int re = x%10;
	while (x)
	{
		char c = re + '0';
		str[i++] = c;
		x = x/10;
		re = x%10;		
	}
	str[i] = '\0';
	j = i-1;
	i = 0;
	for (; i<j; j--,i++)
	{
		char tmp = str[i];
		str[i] = str[j];
		str[j] = tmp;
	}
}




mygets(char str[])
{
	int i = 0;
	char ch1;
	getch(&ch1);
	while (ch1 != '\r')
	{		
		str[i] = ch1;
		putch(str[i]);
		i++;
		getch(&ch1);
	}	
	str[i] = '\0';
	putch('\n');
	putch('\r');
}

myputs(char str[])
{
	int i = 0;
	while (str[i] != '\0')
	{
		putch(str[i]);
		i++;
	}	
	putch('\n');
	putch('\r');
}


showInt(int x)
{
	int i = 0;
	int j = 0;
	char ans[100];
	int re = x%10;
	if (x == 0)
	{
		putch('0');
		return;
	}
	while (x)
	{
		char c = re + '0';
		ans[i++] = c;
		x = x/10;
		re = x%10;		
	}
	j = i-1;
	for (; j >= 0; j--)
		putch(ans[j]);
}

