#include "types.h"
#include "stat.h"
#include "user.h"
#include "sched.h"

int sched_test(int num);

int
sched_test(int num) {
    if (num == 0) {
        return 0;
    }
    setscheduler(SCHED_RR, 0);
    int pid;
    int num_proc = 2;
    for (int i = 0; i < num_proc; i++) {
        pid = fork();
        printf(1, "Proc %d\n", pid);
        if (pid > 0) {
            if (i == num_proc - 1) {
                pid = wait();
            }
        } else if (pid == 0) {
            int k = 0;
            setscheduler(SCHED_RR, 0);
            for (int j = 0; j < 4000000000; j++) {
                k += 1;
                k *= 0.9;
            }
            break;
        } else {
            printf(1, "Fork error\n");
        }
    }
    return 0;
}

int
main(int argc, char *argv[]) {
    sched_test(2);
    exit();
}
