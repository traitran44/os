#include "types.h"
#include "stat.h"
#include "user.h"
#include "sched.h"

int sched_test(int num);

int
sched_test(int num_proc) {
    for (int i = 0; i < num_proc; i++) {
        int pid = fork();
        printf(1, "Proc %d\n", pid);
        if (pid > 0) {
            setscheduler(SCHED_FIFO, 0);
            if (i == num_proc - 1) {
                for (int j = 0; j < num_proc; ++j) {
                    pid = wait();
                }
            }
        } else if (pid == 0) {
            setscheduler(SCHED_FIFO, 0);
            int k = 0;
            for (int j = 0; j < 2000000000; j++) {
                k += 1;
                k *= 0.9;
            }
            printf(1, "DONE!\n");
            return 0;
        } else {
            printf(1, "Fork error\n");
        }
    }
    return 0;
}

int
main(int argc, char *argv[]) {
    sched_test(4);
    exit();
}
