#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(2, "Usage: revreadlink target\n");
        exit(1);
    }

    char buf[256]; 
    int n = revreadlink(argv[1], buf, sizeof(buf));
    if (n < 0) {
        exit(1);
    }
    buf[n] = '\0';

    printf("%s\n",buf);
    exit(0);
}
