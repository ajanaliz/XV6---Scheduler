#include "types.h"
#include "user.h"

int main (void) {
    int pid, pid2, pid3, pid4;
    


    for (i = 0; i < 10; ++i) {
    pid = fork();
    if (pid) {
        for (int i = 0; i < 10; ++i)
        {
          printf(1,"my pid : %d , i is : %d\n",getpid(),i );
        }
      exit();
    } else if (pid == 0) {
      break;
    } else {
      printf("fork error\n");
      exit(1);
    }
  }
  
  
    if (pid) {
        continue;
    } else if (pid == 0) {
        int s;
    wait(&s);
    } else {
        printf("fork error\n");
        exit(1);
    }

exit();
    return 0;
}
