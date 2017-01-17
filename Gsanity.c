#include "types.h"
#include "user.h"
int main (void) {
    pid_t pid, pid2, pid3, pid4;
    int status;
	printf(1,"father pid is %d." , getpid());
	Sleep(10);
    pid = fork();
	if (pid >= 0){
		for(int i = 0; i < 50; i++){
			printf(1,"process %d is printing for the %d time." , getpid(), j);
		}
	}else{
		printf(1, "fork error");
	}
	exit();
	return 0;
}
