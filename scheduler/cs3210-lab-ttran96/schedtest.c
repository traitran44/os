#include "types.h"
#include "stat.h"
#include "user.h"
#include "sched.h"

int sched_test(int num);

int
sched_test(int num_proc) {
    setscheduler(-1, SCHED_FIFO, 99);
    for (int i = 0; i < num_proc; i++) {
        int pid = fork();
        setscheduler(pid, SCHED_RR, i + 3);
        if (pid > 0) {
            if (i == num_proc - 1) {
                for (int j = 0; j < num_proc; ++j) {
                    pid = wait();
                }
            }
        } else if (pid == 0) {
            int k = 0;
            for (int j = 0; j < 40; j++) {
                k += 1;
                k *= 0.9;
            }
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
