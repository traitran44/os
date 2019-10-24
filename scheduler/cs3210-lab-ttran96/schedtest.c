#include "types.h"
#include "stat.h"
#include "user.h"

int sched_test(int num);

int
sched_test(int num) {
    if (num == 0) {
        return 0;
    }
    setscheduler(0);
    int pid;
    for (int i = 0; i < 2; i++) {
        pid = fork();
        if (pid > 0) {
            printf(1, "Parent proc\n");
            if (i == 1) {
                pid = wait();
            }
            printf(1, "Child %d proc done\n",pid);
        } else if (pid == 0) {
            setscheduler(0);
            int k = 0;
            for (int j = 0; j < 4000000000; j++) {
                k += 1;
                k *= 0.9;
            }
            printf(1, "Child proc %d\n", pid);
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