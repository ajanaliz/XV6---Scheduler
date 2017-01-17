#include "types.h"
#include "user.h"


int main(void) {
    
    int childPid[30];
    int avg_waiting = 0, avg_tatime = 0,Q3_waiting=0 , Q3_tatime=0 ,Q2_waiting=0 , Q2_tatime=0 , Q1_waiting=0 , Q1_tatime=0;
    
    for (int i = 0; i < 30; i++) {
        childPid[i] = 0;
    }
    
    for (int i = 0; i < 30; i++) {
        childPid[i] = fork();
        if (childPid[i] < 0) {
            printf(1, "fork failed\n");
            exit();
        } else if (childPid[i] == 0) {
            
            setcid(i);//*******
            if( i % 3 == 0){
                nice();
            }else if (i % 3 == 1){
                nice();
                nice();
            }else {
                //they stay in the same priority
            }
            for(int j=0 ; j<2000 ;  j++){
                // printf(1,"process %d is printing: %d \n", i, j);
            }
            exit();
        } else if (childPid[i] > 0) {
            continue;
        }
    }
    
    
    
    for (int i = 0; i < 30; i++) {
        
        int wtime;
        int rtime;
       
        int q2rtime;
        int q2tatime;
        
        int q3rtime;
        int q3tatime;
              
        int cid;
        
        wait3(&wtime, &rtime, &cid, &q3rtime, &q3tatime ,&q2rtime,&q2tatime);
        
        avg_waiting += wtime;
        avg_tatime += (rtime + wtime);

        //printf(1,"wtime :%d , rtime:%d \n" ,wtime , rtime);
       // printf(1,"1: q3rtime:  %d  && q3tatime: %d  \n",q3rtime,q3tatime);

        //printf(2,"2: q2rtime:  %d  && q2tatime: %d  \n" ,q2rtime,q2tatime);

        if(q3tatime!=255 &&  q2tatime!=255 ){

           /* printf(1,"1\n");
            Q3_tatime+=q3tatime;
            Q3_waiting+=q3tatime - q3rtime;
            
            Q2_waiting+=q2tatime - q2rtime;
            Q2_tatime+=q2tatime;
            
            Q1_waiting+= wtime - (q3tatime - q3rtime) - (q2tatime - q2rtime);
            Q1_tatime+=(rtime + wtime) - (q3tatime) - (q2tatime);*/
	    
	    Q1_waiting+= wtime;
            Q1_tatime+= (rtime + wtime);

        }
        
       else if(q3tatime!=255 &&  q2tatime==255 ){

            //printf(1,"2\n");
          /* Q3_tatime+=q3tatime;
           Q3_waiting+=q3tatime - q3rtime;
           
           Q2_waiting+= wtime - (q3tatime - q3rtime);
           Q2_tatime+= (rtime + wtime) - (q3tatime);*/

	    Q2_waiting+= wtime;
            Q2_tatime+= (rtime + wtime);
        }
        
       else if (q3tatime==255 &&  q2tatime==255 ){
           
	   printf(1,"3\n");
           Q3_tatime+= (rtime + wtime) ;
           Q3_waiting+= wtime;

       }

        
        //printf(1, "cid %d has wtime: %d, rtime: %d, TA time: %d \n", cid, wtime, rtime, wtime + rtime);
        
    }
    printf(1, "average wtime : %d , average turnaround time : %d\n\n", avg_waiting, avg_tatime);
    
   
    printf(1, "Q3 wtime : %d , Q3 turnaround time : %d\n\n", Q3_waiting, Q3_tatime);
    printf(1, "Q2 wtime : %d , Q2 turnaround time : %d\n\n", Q2_waiting, Q2_tatime);
    printf(1, "Q1 wtime : %d , Q1 turnaround time : %d\n\n", Q1_waiting, Q1_tatime);
    exit();
}






















