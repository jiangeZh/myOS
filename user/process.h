void printf(const char * const format,...);
int fork();
void wait();
void exit();
void p(int s);
void v(int s);
int getSem(int value);
void freeSem(int s);
int CountLetter(char str[])
{
	int cnt = 0;
	int i = 0;
	while(str[i++] != '\0')
		cnt++;
	return cnt;
}

void Upper(char str[])
{
	int i = 0;
	while(str[i] != '\0')
	{
		if (str[i] >= 'a' && str[i] <= 'z')
		{
			str[i] += 'A'-'a';
		}
		i++;
	}
}

void delay(int t)
{
	int d = 30000;
	int i,j;
	t = t * 10000;
	for (i = 0; i < d; ++i)
		for(j = 0; j < t; ++j)
		{
			t = t;
		}
}