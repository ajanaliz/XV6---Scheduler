#include "types.h"
#include "user.h"

int main (void) {
    int pid;
    
	printf(1,"father pid is %d.\n" , getpid());
	sleep(10);

       pid = fork();
	if (pid >= 0){
		for(int i = 0; i < 50; i++){
			printf(1,"process %d is printing for the %d time.\n" , getpid(), i);
		}
	}else{
		printf(1, "fork error");
	}
	exit();
	return 0;
}

