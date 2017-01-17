#include "types.h"
#include "user.h"


int main(void) {
	int q1wtime=0,q2wtime=0,q3wtime=0,q1rtime=0,q2rtime=0,q3rtime=0;
    int childPid[30];
	int averagewaitingtime = 0, averageturntime = 0;
    for (int i = 0; i < 30; i++) {
        childPid[i] = 0;
    }

    for (int i = 0; i < 30; i++) {
        childPid[i] = fork();
        if (childPid[i] < 0) {
            printf(1, "fork failed\n");
            exit();
        } else if (childPid[i] == 0) {
            int pid = getpid();
			setcid(i);//*******
            if( i % 3 == 0){
				nice();
			}else if (i % 3 == 1){
				nice();
				nice();
			}else {
				//they stay in the same priority
			}
            exit(pid);
        } else if (childPid[i] > 0) {
            continue;
        }
    }

	int q1tatime=0,q2tatime=0,q3tatime=0;
	
    for (int i = 0; i < 30; i++) {
        int wtime;
        int rtime;
		int cid;
        wait3(&wtime, &rtime, &cid,&q1rtime,&q2rtime,&q3rtime,&q1wtime,&q2wtime,&q3wtime,);
		averagewaitingtime += wtime;
		averageturntime += (rtime + wtime);
        printf(1, "cid %d has wtime: %d, rtime: %d, TA time: %d \n", cid, wtime, rtime, wtime + rtime);
    
    }
    printf(1, "average wtime : %d , average turnaround time : %d\n\n", averagewaitingtime, averageturntime);
    q1tatime = q1rtime + q1wtime;
	q2tatime = q2rtime + q2wtime;
	q3tatime = q3rtime + q3wtime;
	printf(1, "Q1 wtime : %d , Q1 turnaround time : %d\n\n", q1wtime, q1tatime);
    printf(1, "Q2 wtime : %d , Q2 turnaround time : %d\n\n", q2wtime, q2tatime);
    printf(1, "Q3 wtime : %d , Q3 turnaround time : %d\n\n", q3wtime, q3tatime);
    exit(0);
}