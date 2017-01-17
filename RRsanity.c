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
            int pid = getpid();
            for (int j = 0; j < 10; j++) {
                printf(1, "Child %d prints for the %d time\n", pid, j);
            }
            exit();
        } else if (childPid[i] > 0) {
            continue;
        }
    }

    for (int i = 0; i < 10; i++) {
        int wtime;
        int rtime;

        getppid(&wtime, &rtime);

        printf(1, "child %d : ", i);
        printf(1, "wtime : %d , rtime : %d , turnaround time : %d\n\n", wtime, rtime, wtime + rtime);
    }
    exit();
}
