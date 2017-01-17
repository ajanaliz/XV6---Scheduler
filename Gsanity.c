#include "types.h"
#include "user.h"


int main(void) {
    
   printf(1, "father pid is %d\n", getpid());
    sleep(100);
    
    fork();

    for (int i = 0; i < 50; i++) {
        printf(1,"process %d is printing for the %d time.\n" ,getpid(), i);
    }
    
    
    exit();
}
