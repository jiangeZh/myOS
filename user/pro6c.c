#include "pro6.h"

char ch,str[80];
int a=1234;

main(){
	scanf("a=%d",&a);
   	gets(str);
	puts(str);
   	getch(&ch);
	putch(ch);
	printf("ch=%c, a=%d, str=%s", ch, a, str);

}
