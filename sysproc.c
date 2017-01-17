#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}
int 
sys_getppid (void){

	char *wtime = 0 , *rtime = 0;
    
    argptr(0 , &wtime , sizeof(int));
    argptr(1 , &rtime , sizeof(int));

    *wtime = (proc->etime - proc->ctime) - proc->rtime;
    *rtime = proc->rtime;

    return 0;

}
int 
sys_setcid (void){

 	int z  ;
	argint(0,&z);
	proc->cid= z;
	return 1;
}
int 
sys_nice (void){

if(proc-> queuelevel >1){
	if(proc->queuelevel==3){
		proc->q3rtime = (proc->rtime);
		proc->q3tatime = ticks-(proc->ctime);
//cprintf("1: proc->q1rtime:  %d  &&   proc->q1tatime: %d && proc->qlevel: %d \n",proc->q3rtime ,proc->q3tatime,proc->queuelevel);
			}
	if(proc->queuelevel==2){
		proc->q2rtime = (proc->rtime - (proc->q3rtime));
		proc->q2tatime = ticks-(proc->ctime)-proc->q3tatime;
//cprintf("2: proc->q1rtime:  %d  &&   proc->q1tatime: %d && proc->qlevel: %d \n",proc->q2rtime ,proc->q2tatime,proc->queuelevel);
			}
	proc->queuelevel -- ;
	
		return 1;
			}
	return 0;
}

int
sys_wait2(void){
	
char *wtime = 0 , *rtime = 0;

    argptr(0 , &wtime , sizeof(int));
    argptr(1 , &rtime , sizeof(int));
    return wait22(wtime,rtime);
}
int
sys_wait3(void){

    char *wtime = 0 , *rtime = 0 , *cid=0 , *q3rtime =0 , *q3tatime=0 , *q2rtime =0 , *q2tatime=0;
	argptr(0 , &wtime , sizeof(int));
	argptr(1 , &rtime , sizeof(int)); 
	argptr(2 , &cid , sizeof(int));
	argptr(3 , &q3rtime , sizeof(int));
	argptr(4 , &q3tatime , sizeof(int));
	argptr(5 , &q2rtime , sizeof(int));
	argptr(6 , &q2tatime , sizeof(int));

    return wait33(wtime,rtime,cid, q3rtime,q3tatime,q2rtime,q2tatime);
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
