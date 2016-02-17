extern void getch(char* ch);
extern void putch(char ch);
extern void gets(char str[]);
extern void puts(char str[]);
extern void printf(const char * const format,...);

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

scanf(const char *format,...)
{
	int i = 0;
	int j = 0;
	int* sp = (int*)(&format);
	char s[50];
	mygets(s);
	sp += sizeof(format)/2;
	while (format[i] != '\0' && s[j] != '\0')
	{
		if (format[i] == ' ')
			i++;
		else if (format[i] == '%')
		{
			i++;
			if (format[i] != '\0')
			{
				
				if (format[i] == 'c')
				{									
					char* mysp = (char*)(*sp);										
					(*mysp) = s[j++];
					sp += sizeof(format)/2;
				}
				else if (format[i] == 's')
				{
					int k = 0;	
					char* mysp = (char*)(*sp);
					while (s[j] != '\0')
						(mysp)[k++] = s[j++];
					sp += sizeof(format)/2;
				}
				else if (format[i] == 'd')
				{
					int ans = 0;
					int* mysp = (int*)(*sp);
					while (s[j] >= '0' && s[j] <= '9')
					{
						ans = ans*10+s[j++]-'0';
					}
					(*mysp) = ans;
					sp += sizeof(format)/2;
				}
			}
			i++;
		}
		else 
		{
			if (s[j] != format[i])
				break;	
			i++;
			j++;
		}
	
	}
}