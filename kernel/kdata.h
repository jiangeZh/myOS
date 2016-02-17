int NEW = 0;
int READY = 1;
int RUNNING = 2;
int EXIT = 3;
int BLOCKED = 4;
int FREE = 5;
int BUSY = 6;
#define NULL (void*)0

typedef struct RegisterImage{
	int SS;
	int GS;
	int FS;
	int ES;
	int DS;
	int DI;
	int SI;
	int BP;
	int SP;
	int BX;
	int DX;
	int CX;
	int AX;
	int IP;
	int CS;
	int FLAGS;
}RegisterImage;

typedef struct PCB{
	RegisterImage regImg;
	int Status;
	int used;
	int pcbFID;
	int pcbID;
	struct PCB* next;
}PCB;

const int semMax = 100;

typedef struct semaphone{
    int count;
    PCB *head;
    int used;
}semaphone;

semaphone semList[100];
PCB pcb_list[8];
int CurrentPCBno = 0; 
int Program_Num = 0;

PCB* Current_Process();
void Save_Process(int,int, int, int, int, int, int, int,
		  int,int,int,int, int,int, int,int );
void init(PCB*, int, int);
void Schedule();
void special();
void memcopy(PCB * F_PCB, PCB * C_PCB);
extern void stackcopy(int ss,int sp); 
void wakeup(PCB * pp, int s);
void do_p(int s);
void do_v(int s);
int do_getSem(int value);
void do_freeSem(int id);

void freeAll()
{
	int i = 0;
	for (; i < 8; ++i)
	{
		pcb_list[i].used = FREE;
	}
}

void Save_Process(int gs,int fs,int es,int ds,int di,int si,int bp,
		int sp,int dx,int cx,int bx,int ax,int ss,int ip,int cs,int flags)
{
	pcb_list[CurrentPCBno].regImg.AX = ax;
	pcb_list[CurrentPCBno].regImg.BX = bx;
	pcb_list[CurrentPCBno].regImg.CX = cx;
	pcb_list[CurrentPCBno].regImg.DX = dx;

	pcb_list[CurrentPCBno].regImg.DS = ds;
	pcb_list[CurrentPCBno].regImg.ES = es;
	pcb_list[CurrentPCBno].regImg.FS = fs;
	pcb_list[CurrentPCBno].regImg.GS = gs;
	pcb_list[CurrentPCBno].regImg.SS = ss;

	pcb_list[CurrentPCBno].regImg.IP = ip;
	pcb_list[CurrentPCBno].regImg.CS = cs;
	pcb_list[CurrentPCBno].regImg.FLAGS = flags;
	pcb_list[CurrentPCBno].regImg.DI = di;
	pcb_list[CurrentPCBno].regImg.SI = si;
	pcb_list[CurrentPCBno].regImg.SP = sp;
	pcb_list[CurrentPCBno].regImg.BP = bp;
}

void Schedule(){
	if (pcb_list[CurrentPCBno].Status != BLOCKED)
		pcb_list[CurrentPCBno].Status = READY;
	CurrentPCBno ++;
	if( CurrentPCBno > Program_Num )
		CurrentPCBno = 1;
	while(1)
	{
		if( pcb_list[CurrentPCBno].Status == NEW )
		{
			break;
		}	
		else if ( pcb_list[CurrentPCBno].Status != BLOCKED )
		{
			pcb_list[CurrentPCBno].Status = RUNNING;
			break;
		}			
		else
		{
			CurrentPCBno ++;
			if( CurrentPCBno > Program_Num )
				CurrentPCBno = 1;
		}
	}
}
PCB* Current_Process(){

	return &pcb_list[CurrentPCBno];
}

void init(PCB* pcb,int segement, int offset)
{
	pcb->regImg.GS = 0xb800;
	pcb->regImg.SS = segement;
	pcb->regImg.ES = segement;
	pcb->regImg.DS = segement;
	pcb->regImg.CS = segement;
	pcb->regImg.FS = segement;
	pcb->regImg.IP = offset;
	pcb->regImg.SP = 0x100;
	pcb->regImg.AX = 0;
	pcb->regImg.BX = 0;
	pcb->regImg.CX = 0;
	pcb->regImg.DX = 0;
	pcb->regImg.DI = 0;
	pcb->regImg.SI = 0;
	pcb->regImg.BP = 0;
	pcb->regImg.FLAGS = 512;
	pcb->Status = NEW;
	pcb->used = BUSY;
	pcb->next = NULL;
}

void special()
{
	if(pcb_list[CurrentPCBno].Status==NEW)
		pcb_list[CurrentPCBno].Status=RUNNING;
}

int do_fork()
{
	PCB* p;
	int flag = 0;
	int i = 1;
	for (; i < 8; ++i)
	{
		if (pcb_list[i].used == FREE)
		{
			flag = 1;
			p = &(pcb_list[i]);
			memcopy( &pcb_list[CurrentPCBno], p );
			stackcopy(pcb_list[CurrentPCBno].regImg.SS,pcb_list[CurrentPCBno].regImg.SP/0x1000*0x1000);
			p -> pcbID = i;
			p -> pcbFID = CurrentPCBno;
			p -> Status = READY;
			p -> used = BUSY;
			pcb_list[CurrentPCBno].regImg.AX = p -> pcbID;
			p -> regImg.AX = 0;
			Program_Num++;
			break;
		}
	}
	if (flag == 0)
	{
		pcb_list[CurrentPCBno].regImg.AX = -1;
	}
}

void memcopy(PCB * F_PCB, PCB * C_PCB )
{
	C_PCB -> regImg.SP = F_PCB -> regImg.SP+0x1000;
	C_PCB -> regImg.SS = F_PCB -> regImg.SS;
	C_PCB -> regImg.GS = F_PCB -> regImg.GS;
	C_PCB -> regImg.ES = F_PCB -> regImg.ES;
	C_PCB -> regImg.DS = F_PCB -> regImg.DS;
	C_PCB -> regImg.CS = F_PCB -> regImg.CS;
	C_PCB -> regImg.FS = F_PCB -> regImg.FS;
	C_PCB -> regImg.IP = F_PCB -> regImg.IP;
	C_PCB -> regImg.AX = F_PCB -> regImg.AX;
	C_PCB -> regImg.BX = F_PCB -> regImg.BX;
	C_PCB -> regImg.CX = F_PCB -> regImg.CX;
	C_PCB -> regImg.DX = F_PCB -> regImg.DX;
	C_PCB -> regImg.DI = F_PCB -> regImg.DI;
	C_PCB -> regImg.SI = F_PCB -> regImg.SI;
	C_PCB -> regImg.BP = F_PCB -> regImg.BP;
	C_PCB -> regImg.FLAGS = F_PCB -> regImg.FLAGS;	
}

void do_wait(int s) {
	pcb_list[CurrentPCBno].Status = BLOCKED;
	pcb_list[CurrentPCBno].next = semList[s].head;
	semList[s].head = &pcb_list[CurrentPCBno];
	Schedule();
}

void wakeup(PCB * pp, int s)
{
	pp->Status=READY;
	if (s != -1)
	{
		semList[s].head = pp->next;
	}
}

void do_exit(int a) {
       pcb_list[CurrentPCBno].Status=EXIT;
       pcb_list[CurrentPCBno].used=FREE; 
       wakeup(&pcb_list[pcb_list[CurrentPCBno].pcbFID],-1);
       pcb_list[pcb_list[CurrentPCBno].pcbFID].regImg.AX=a;
       Program_Num--;
       Schedule();
}

int do_getSem(int value) {
    int i = 0;
    while(semList[i].used){i++;}
    if (i < semMax) {
      semList[i].used = 1;
      semList[i].count = value;
      semList[i].head = NULL;
      return i; 
    }
   else
      return(-1);
}

void do_freeSem(int id) {
	semList[id].used = 0;
}

void do_p(int s) {
   semList[s].count--;
   if (semList[s].count < 0)  
	do_wait(s);
}

void do_v(int s) {
   semList[s].count++;
   if (semList[s].count <= 0)  
	wakeup(semList[s].head,s);
}
