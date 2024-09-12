#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int match(char *s, char key){
    int ct = 0;
    for(; *s; s++){
        if( s[0] == key ) ++ct;
    }
    return ct;
}

int *traverse(char *path, char key)
{
    int *count = malloc(sizeof(int) * 3); 
    for(int i = 0; i < 3; ++i) count[i] = 0;
    fprintf(1, "%s %d\n", path, match(path, key));

    char buf[128], *p;
    struct dirent de;
    int fd;
    struct stat st;

    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';

    if((fd = open(path, 0)) < 0){
        fprintf(2, "open error: %s\n", path);
        exit(-1);
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "stat error: %s\n", path);
        close(fd);
        exit(-1);
    }

    int num;
    int idx = 0;
    
    switch(st.type){
        case T_FILE:
            count[T_FILE]++;
            break;
        case T_DIR:
            count[T_DIR]++;
            num = st.size / sizeof(de);
            
            // printf("entry number is : %d\n", num );
            
            /**********************The format of buf is now "path/"************************/
            while (1)
            {
                int n = read(fd, &de, sizeof(de));
                idx += n / sizeof(de);
                if( strcmp(de.name, "") == 0 ){
                    break;
                } 
                if( strcmp(de.name, ".") == 0 ){
                    continue;
                } 
                if( strcmp(de.name, "..") == 0){
                    if( idx == num )    
                        break;
                    else
                        continue;
                }
                
                memmove(p, de.name, DIRSIZ);
                p[DIRSIZ] = 0;

                int *tmp = traverse(buf, key);
                count[T_FILE] += tmp[T_FILE];
                count[T_DIR] += tmp[T_DIR];
                free(tmp);
                if( idx == num ) break;
            }
            break;
    }
    close(fd);
    return count; 
}



int main(int argc, char *argv[]){
    if(argc != 3){
        fprintf(2, "usage: mp0 [root_directory] [key]\n");
        exit(1);
    }
    
    int pid; 
    char buf[128];
    int ptoc[2], ctop[2];

    if(pipe(ptoc) < 0 || pipe(ctop) < 0){
        printf("pipe error\n");
        exit(1);
    }

    if((pid = fork()) < 0){
        printf("fork error\n");
        exit(1);    
    }
    else if(pid == 0){
        char root[15];
        char key[2];
        close(ptoc[1]);
        close(ctop[0]);
        read(ptoc[0], root, sizeof(root));
        write(ctop[1], "got it", 7);
        read(ptoc[0], key, sizeof(key));
        
        // printf("root: %s\n", root);
        // printf("key: %s\n", key);
        /********************finish read parameter**************************/

        int fd;
        struct stat st;
        char split[5];

        if((fd = open(root, 0)) < 0){
            fprintf(1, "%s [error opening dir]\n", root);
            fprintf(ctop[1], "%d", 0);
            read(ptoc[0], split, 5);
            fprintf(ctop[1], "%d", 0);
            close(ctop[1]);
            exit(0);
        }
        if(fstat(fd, &st) < 0){
            fprintf(2, "ls: cannot stat %s\n", root);
            close(fd);
            close(ctop[1]);
            exit(0);
        }

        int *ans_num;
        switch(st.type){
            case T_FILE:
                fprintf(1, "%s [error opening dir]\n", root);
                fprintf(ctop[1], "%d", 0);
                read(ptoc[0], split, 5);
                fprintf(ctop[1], "%d", 0);
                break;

            case T_DIR:
                ans_num = traverse(root, key[0]);
                ans_num[T_DIR] -= 1; // decrease root itself
                fprintf(ctop[1], "%d", ans_num[T_DIR]);
                read(ptoc[0], split, 5);
                fprintf(ctop[1], "%d", ans_num[T_FILE]);
                free(ans_num);
                break;
        }
        close(ptoc[0]);
        close(fd);
        close(ctop[1]);
    }
    else{
        close(ptoc[0]);
        close(ctop[1]);
        write(ptoc[1], argv[1], strlen(argv[1]) + 1);
        read(ctop[0], buf, sizeof(buf));
        if( strcmp(buf, "got it") == 0 ){
            write(ptoc[1], argv[2], strlen(argv[2]) + 1);
        }
        /********************finish passing parameter to child*********************/
        int dir, file;
        int n;
        n = read(ctop[0], buf, sizeof(buf)); // read DIR num
        buf[n] = '\0';
        dir = atoi(buf);
        /***********************finish read dir num******************************/
        write(ptoc[1], "ok", 3);
        n = read(ctop[0], buf, sizeof(buf)); // read FILE num
        buf[n] = '\0';
        file = atoi(buf);
        /***********************finish read file num******************************/
        close(ptoc[1]);
        close(ctop[0]);
        wait((void*)0);
        printf("\n%d directories, %d files\n", dir, file);
    }

    exit(0);
}