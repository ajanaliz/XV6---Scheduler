#include "types.h"
#include "user.h"


int main(void) {
    int childPid[10];
    for (int i = 0; i < 10; i++) {
        childPid[i] = 0;
    }

    for (int i = 0; i < 10; i++) {
        childPid[i] = fork();
        if (childPid[i] < 0) {
           printf(1, "fork failed\n");
            exit();
        } else if (childPid[i] == 0) {
            
            for (int j = 0; j < 1000; j++) {
               ;
            }
            exit();
        } else if (childPid[i] > 0) {
            continue;
        }
    }

    for (int i = 0; i < 10; i++) {
        int wtime;
        int rtime;

        wait2(&wtime, &rtime);

    }
    exit();
}
