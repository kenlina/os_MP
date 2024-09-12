
user/_mp1-part2-6:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <task2>:

static struct thread *t;
static int cnt = 0;
static int cnt_task1 = 1, cnt_task2 = 1;

void task2(void *arg){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    printf("task2: %d\n", cnt_task2);
   a:	00001497          	auipc	s1,0x1
   e:	e0a48493          	addi	s1,s1,-502 # e14 <cnt_task2>
  12:	408c                	lw	a1,0(s1)
  14:	00001517          	auipc	a0,0x1
  18:	d9450513          	addi	a0,a0,-620 # da8 <thread_assign_task+0x64>
  1c:	00000097          	auipc	ra,0x0
  20:	794080e7          	jalr	1940(ra) # 7b0 <printf>
    cnt_task2++;
  24:	409c                	lw	a5,0(s1)
  26:	2785                	addiw	a5,a5,1
  28:	c09c                	sw	a5,0(s1)
    if (cnt_task2 & 1){
  2a:	8b85                	andi	a5,a5,1
  2c:	e791                	bnez	a5,38 <task2+0x38>
        thread_yield();
    }
}
  2e:	60e2                	ld	ra,24(sp)
  30:	6442                	ld	s0,16(sp)
  32:	64a2                	ld	s1,8(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret
        thread_yield();
  38:	00001097          	auipc	ra,0x1
  3c:	c5a080e7          	jalr	-934(ra) # c92 <thread_yield>
}
  40:	b7fd                	j	2e <task2+0x2e>

0000000000000042 <task1>:

void task1(void *arg){
  42:	7179                	addi	sp,sp,-48
  44:	f406                	sd	ra,40(sp)
  46:	f022                	sd	s0,32(sp)
  48:	ec26                	sd	s1,24(sp)
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  4e:	e052                	sd	s4,0(sp)
  50:	1800                	addi	s0,sp,48
    printf("task1: %d\n", cnt_task1);
  52:	00001597          	auipc	a1,0x1
  56:	dc65a583          	lw	a1,-570(a1) # e18 <cnt_task1>
  5a:	00001517          	auipc	a0,0x1
  5e:	d5e50513          	addi	a0,a0,-674 # db8 <thread_assign_task+0x74>
  62:	00000097          	auipc	ra,0x0
  66:	74e080e7          	jalr	1870(ra) # 7b0 <printf>

    int i = 0;
    while (i < cnt){
  6a:	00001797          	auipc	a5,0x1
  6e:	db67a783          	lw	a5,-586(a5) # e20 <cnt>
  72:	02f05c63          	blez	a5,aa <task1+0x68>
    int i = 0;
  76:	4481                	li	s1,0
        thread_assign_task(t, task2, NULL);
  78:	00001a17          	auipc	s4,0x1
  7c:	db0a0a13          	addi	s4,s4,-592 # e28 <t>
  80:	00000997          	auipc	s3,0x0
  84:	f8098993          	addi	s3,s3,-128 # 0 <task2>
    while (i < cnt){
  88:	00001917          	auipc	s2,0x1
  8c:	d9890913          	addi	s2,s2,-616 # e20 <cnt>
        thread_assign_task(t, task2, NULL);
  90:	4601                	li	a2,0
  92:	85ce                	mv	a1,s3
  94:	000a3503          	ld	a0,0(s4)
  98:	00001097          	auipc	ra,0x1
  9c:	cac080e7          	jalr	-852(ra) # d44 <thread_assign_task>
        i++;
  a0:	2485                	addiw	s1,s1,1
    while (i < cnt){
  a2:	00092783          	lw	a5,0(s2)
  a6:	fef4c5e3          	blt	s1,a5,90 <task1+0x4e>
    }

    if (cnt_task1 % 3 == 0){
  aa:	00001797          	auipc	a5,0x1
  ae:	d6e7a783          	lw	a5,-658(a5) # e18 <cnt_task1>
  b2:	470d                	li	a4,3
  b4:	02e7e7bb          	remw	a5,a5,a4
  b8:	c385                	beqz	a5,d8 <task1+0x96>
        thread_yield();
    }
    cnt_task1++;
  ba:	00001717          	auipc	a4,0x1
  be:	d5e70713          	addi	a4,a4,-674 # e18 <cnt_task1>
  c2:	431c                	lw	a5,0(a4)
  c4:	2785                	addiw	a5,a5,1
  c6:	c31c                	sw	a5,0(a4)
}
  c8:	70a2                	ld	ra,40(sp)
  ca:	7402                	ld	s0,32(sp)
  cc:	64e2                	ld	s1,24(sp)
  ce:	6942                	ld	s2,16(sp)
  d0:	69a2                	ld	s3,8(sp)
  d2:	6a02                	ld	s4,0(sp)
  d4:	6145                	addi	sp,sp,48
  d6:	8082                	ret
        thread_yield();
  d8:	00001097          	auipc	ra,0x1
  dc:	bba080e7          	jalr	-1094(ra) # c92 <thread_yield>
  e0:	bfe9                	j	ba <task1+0x78>

00000000000000e2 <f1>:

void f1(void *arg)
{   
    while (cnt < LEN){
  e2:	00001597          	auipc	a1,0x1
  e6:	d3e5a583          	lw	a1,-706(a1) # e20 <cnt>
  ea:	47a5                	li	a5,9
  ec:	06b7cc63          	blt	a5,a1,164 <f1+0x82>
{   
  f0:	7139                	addi	sp,sp,-64
  f2:	fc06                	sd	ra,56(sp)
  f4:	f822                	sd	s0,48(sp)
  f6:	f426                	sd	s1,40(sp)
  f8:	f04a                	sd	s2,32(sp)
  fa:	ec4e                	sd	s3,24(sp)
  fc:	e852                	sd	s4,16(sp)
  fe:	e456                	sd	s5,8(sp)
 100:	0080                	addi	s0,sp,64
        printf("thread: %d\n", cnt);
 102:	00001a97          	auipc	s5,0x1
 106:	cc6a8a93          	addi	s5,s5,-826 # dc8 <thread_assign_task+0x84>
        thread_assign_task(t, task1, NULL);
 10a:	00001a17          	auipc	s4,0x1
 10e:	d1ea0a13          	addi	s4,s4,-738 # e28 <t>
 112:	00000997          	auipc	s3,0x0
 116:	f3098993          	addi	s3,s3,-208 # 42 <task1>
        cnt++;
 11a:	00001497          	auipc	s1,0x1
 11e:	d0648493          	addi	s1,s1,-762 # e20 <cnt>
    while (cnt < LEN){
 122:	4925                	li	s2,9
        printf("thread: %d\n", cnt);
 124:	8556                	mv	a0,s5
 126:	00000097          	auipc	ra,0x0
 12a:	68a080e7          	jalr	1674(ra) # 7b0 <printf>
        thread_assign_task(t, task1, NULL);
 12e:	4601                	li	a2,0
 130:	85ce                	mv	a1,s3
 132:	000a3503          	ld	a0,0(s4)
 136:	00001097          	auipc	ra,0x1
 13a:	c0e080e7          	jalr	-1010(ra) # d44 <thread_assign_task>
        cnt++;
 13e:	409c                	lw	a5,0(s1)
 140:	2785                	addiw	a5,a5,1
 142:	c09c                	sw	a5,0(s1)
        thread_yield();
 144:	00001097          	auipc	ra,0x1
 148:	b4e080e7          	jalr	-1202(ra) # c92 <thread_yield>
    while (cnt < LEN){
 14c:	408c                	lw	a1,0(s1)
 14e:	fcb95be3          	bge	s2,a1,124 <f1+0x42>
    }
}
 152:	70e2                	ld	ra,56(sp)
 154:	7442                	ld	s0,48(sp)
 156:	74a2                	ld	s1,40(sp)
 158:	7902                	ld	s2,32(sp)
 15a:	69e2                	ld	s3,24(sp)
 15c:	6a42                	ld	s4,16(sp)
 15e:	6aa2                	ld	s5,8(sp)
 160:	6121                	addi	sp,sp,64
 162:	8082                	ret
 164:	8082                	ret

0000000000000166 <main>:

int main(int argc, char **argv)
{
 166:	1141                	addi	sp,sp,-16
 168:	e406                	sd	ra,8(sp)
 16a:	e022                	sd	s0,0(sp)
 16c:	0800                	addi	s0,sp,16
    printf("mp1-part2-6\n");
 16e:	00001517          	auipc	a0,0x1
 172:	c6a50513          	addi	a0,a0,-918 # dd8 <thread_assign_task+0x94>
 176:	00000097          	auipc	ra,0x0
 17a:	63a080e7          	jalr	1594(ra) # 7b0 <printf>
    t = thread_create(f1, NULL);
 17e:	4581                	li	a1,0
 180:	00000517          	auipc	a0,0x0
 184:	f6250513          	addi	a0,a0,-158 # e2 <f1>
 188:	00001097          	auipc	ra,0x1
 18c:	840080e7          	jalr	-1984(ra) # 9c8 <thread_create>
 190:	00001797          	auipc	a5,0x1
 194:	c8a7bc23          	sd	a0,-872(a5) # e28 <t>
    thread_add_runqueue(t);
 198:	00001097          	auipc	ra,0x1
 19c:	89e080e7          	jalr	-1890(ra) # a36 <thread_add_runqueue>
    thread_start_threading();
 1a0:	00001097          	auipc	ra,0x1
 1a4:	b78080e7          	jalr	-1160(ra) # d18 <thread_start_threading>
    printf("\nexited\n");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	c4050513          	addi	a0,a0,-960 # de8 <thread_assign_task+0xa4>
 1b0:	00000097          	auipc	ra,0x0
 1b4:	600080e7          	jalr	1536(ra) # 7b0 <printf>
    exit(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	27e080e7          	jalr	638(ra) # 438 <exit>

00000000000001c2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c8:	87aa                	mv	a5,a0
 1ca:	0585                	addi	a1,a1,1
 1cc:	0785                	addi	a5,a5,1
 1ce:	fff5c703          	lbu	a4,-1(a1)
 1d2:	fee78fa3          	sb	a4,-1(a5)
 1d6:	fb75                	bnez	a4,1ca <strcpy+0x8>
    ;
  return os;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cb91                	beqz	a5,1fc <strcmp+0x1e>
 1ea:	0005c703          	lbu	a4,0(a1)
 1ee:	00f71763          	bne	a4,a5,1fc <strcmp+0x1e>
    p++, q++;
 1f2:	0505                	addi	a0,a0,1
 1f4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	fbe5                	bnez	a5,1ea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1fc:	0005c503          	lbu	a0,0(a1)
}
 200:	40a7853b          	subw	a0,a5,a0
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret

000000000000020a <strlen>:

uint
strlen(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 210:	00054783          	lbu	a5,0(a0)
 214:	cf91                	beqz	a5,230 <strlen+0x26>
 216:	0505                	addi	a0,a0,1
 218:	87aa                	mv	a5,a0
 21a:	4685                	li	a3,1
 21c:	9e89                	subw	a3,a3,a0
 21e:	00f6853b          	addw	a0,a3,a5
 222:	0785                	addi	a5,a5,1
 224:	fff7c703          	lbu	a4,-1(a5)
 228:	fb7d                	bnez	a4,21e <strlen+0x14>
    ;
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  for(n = 0; s[n]; n++)
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <strlen+0x20>

0000000000000234 <memset>:

void*
memset(void *dst, int c, uint n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 23a:	ce09                	beqz	a2,254 <memset+0x20>
 23c:	87aa                	mv	a5,a0
 23e:	fff6071b          	addiw	a4,a2,-1
 242:	1702                	slli	a4,a4,0x20
 244:	9301                	srli	a4,a4,0x20
 246:	0705                	addi	a4,a4,1
 248:	972a                	add	a4,a4,a0
    cdst[i] = c;
 24a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 24e:	0785                	addi	a5,a5,1
 250:	fee79de3          	bne	a5,a4,24a <memset+0x16>
  }
  return dst;
}
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <strchr>:

char*
strchr(const char *s, char c)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 260:	00054783          	lbu	a5,0(a0)
 264:	cb99                	beqz	a5,27a <strchr+0x20>
    if(*s == c)
 266:	00f58763          	beq	a1,a5,274 <strchr+0x1a>
  for(; *s; s++)
 26a:	0505                	addi	a0,a0,1
 26c:	00054783          	lbu	a5,0(a0)
 270:	fbfd                	bnez	a5,266 <strchr+0xc>
      return (char*)s;
  return 0;
 272:	4501                	li	a0,0
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  return 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <strchr+0x1a>

000000000000027e <gets>:

char*
gets(char *buf, int max)
{
 27e:	711d                	addi	sp,sp,-96
 280:	ec86                	sd	ra,88(sp)
 282:	e8a2                	sd	s0,80(sp)
 284:	e4a6                	sd	s1,72(sp)
 286:	e0ca                	sd	s2,64(sp)
 288:	fc4e                	sd	s3,56(sp)
 28a:	f852                	sd	s4,48(sp)
 28c:	f456                	sd	s5,40(sp)
 28e:	f05a                	sd	s6,32(sp)
 290:	ec5e                	sd	s7,24(sp)
 292:	1080                	addi	s0,sp,96
 294:	8baa                	mv	s7,a0
 296:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 298:	892a                	mv	s2,a0
 29a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 29c:	4aa9                	li	s5,10
 29e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2a0:	89a6                	mv	s3,s1
 2a2:	2485                	addiw	s1,s1,1
 2a4:	0344d863          	bge	s1,s4,2d4 <gets+0x56>
    cc = read(0, &c, 1);
 2a8:	4605                	li	a2,1
 2aa:	faf40593          	addi	a1,s0,-81
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	1a0080e7          	jalr	416(ra) # 450 <read>
    if(cc < 1)
 2b8:	00a05e63          	blez	a0,2d4 <gets+0x56>
    buf[i++] = c;
 2bc:	faf44783          	lbu	a5,-81(s0)
 2c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c4:	01578763          	beq	a5,s5,2d2 <gets+0x54>
 2c8:	0905                	addi	s2,s2,1
 2ca:	fd679be3          	bne	a5,s6,2a0 <gets+0x22>
  for(i=0; i+1 < max; ){
 2ce:	89a6                	mv	s3,s1
 2d0:	a011                	j	2d4 <gets+0x56>
 2d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d4:	99de                	add	s3,s3,s7
 2d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2da:	855e                	mv	a0,s7
 2dc:	60e6                	ld	ra,88(sp)
 2de:	6446                	ld	s0,80(sp)
 2e0:	64a6                	ld	s1,72(sp)
 2e2:	6906                	ld	s2,64(sp)
 2e4:	79e2                	ld	s3,56(sp)
 2e6:	7a42                	ld	s4,48(sp)
 2e8:	7aa2                	ld	s5,40(sp)
 2ea:	7b02                	ld	s6,32(sp)
 2ec:	6be2                	ld	s7,24(sp)
 2ee:	6125                	addi	sp,sp,96
 2f0:	8082                	ret

00000000000002f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f2:	1101                	addi	sp,sp,-32
 2f4:	ec06                	sd	ra,24(sp)
 2f6:	e822                	sd	s0,16(sp)
 2f8:	e426                	sd	s1,8(sp)
 2fa:	e04a                	sd	s2,0(sp)
 2fc:	1000                	addi	s0,sp,32
 2fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 300:	4581                	li	a1,0
 302:	00000097          	auipc	ra,0x0
 306:	176080e7          	jalr	374(ra) # 478 <open>
  if(fd < 0)
 30a:	02054563          	bltz	a0,334 <stat+0x42>
 30e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 310:	85ca                	mv	a1,s2
 312:	00000097          	auipc	ra,0x0
 316:	17e080e7          	jalr	382(ra) # 490 <fstat>
 31a:	892a                	mv	s2,a0
  close(fd);
 31c:	8526                	mv	a0,s1
 31e:	00000097          	auipc	ra,0x0
 322:	142080e7          	jalr	322(ra) # 460 <close>
  return r;
}
 326:	854a                	mv	a0,s2
 328:	60e2                	ld	ra,24(sp)
 32a:	6442                	ld	s0,16(sp)
 32c:	64a2                	ld	s1,8(sp)
 32e:	6902                	ld	s2,0(sp)
 330:	6105                	addi	sp,sp,32
 332:	8082                	ret
    return -1;
 334:	597d                	li	s2,-1
 336:	bfc5                	j	326 <stat+0x34>

0000000000000338 <atoi>:

int
atoi(const char *s)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33e:	00054603          	lbu	a2,0(a0)
 342:	fd06079b          	addiw	a5,a2,-48
 346:	0ff7f793          	andi	a5,a5,255
 34a:	4725                	li	a4,9
 34c:	02f76963          	bltu	a4,a5,37e <atoi+0x46>
 350:	86aa                	mv	a3,a0
  n = 0;
 352:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 354:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 356:	0685                	addi	a3,a3,1
 358:	0025179b          	slliw	a5,a0,0x2
 35c:	9fa9                	addw	a5,a5,a0
 35e:	0017979b          	slliw	a5,a5,0x1
 362:	9fb1                	addw	a5,a5,a2
 364:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 368:	0006c603          	lbu	a2,0(a3)
 36c:	fd06071b          	addiw	a4,a2,-48
 370:	0ff77713          	andi	a4,a4,255
 374:	fee5f1e3          	bgeu	a1,a4,356 <atoi+0x1e>
  return n;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  n = 0;
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <atoi+0x40>

0000000000000382 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 388:	02b57663          	bgeu	a0,a1,3b4 <memmove+0x32>
    while(n-- > 0)
 38c:	02c05163          	blez	a2,3ae <memmove+0x2c>
 390:	fff6079b          	addiw	a5,a2,-1
 394:	1782                	slli	a5,a5,0x20
 396:	9381                	srli	a5,a5,0x20
 398:	0785                	addi	a5,a5,1
 39a:	97aa                	add	a5,a5,a0
  dst = vdst;
 39c:	872a                	mv	a4,a0
      *dst++ = *src++;
 39e:	0585                	addi	a1,a1,1
 3a0:	0705                	addi	a4,a4,1
 3a2:	fff5c683          	lbu	a3,-1(a1)
 3a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3aa:	fee79ae3          	bne	a5,a4,39e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
    dst += n;
 3b4:	00c50733          	add	a4,a0,a2
    src += n;
 3b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ba:	fec05ae3          	blez	a2,3ae <memmove+0x2c>
 3be:	fff6079b          	addiw	a5,a2,-1
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	fff7c793          	not	a5,a5
 3ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3cc:	15fd                	addi	a1,a1,-1
 3ce:	177d                	addi	a4,a4,-1
 3d0:	0005c683          	lbu	a3,0(a1)
 3d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d8:	fee79ae3          	bne	a5,a4,3cc <memmove+0x4a>
 3dc:	bfc9                	j	3ae <memmove+0x2c>

00000000000003de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e4:	ca05                	beqz	a2,414 <memcmp+0x36>
 3e6:	fff6069b          	addiw	a3,a2,-1
 3ea:	1682                	slli	a3,a3,0x20
 3ec:	9281                	srli	a3,a3,0x20
 3ee:	0685                	addi	a3,a3,1
 3f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3f2:	00054783          	lbu	a5,0(a0)
 3f6:	0005c703          	lbu	a4,0(a1)
 3fa:	00e79863          	bne	a5,a4,40a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3fe:	0505                	addi	a0,a0,1
    p2++;
 400:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 402:	fed518e3          	bne	a0,a3,3f2 <memcmp+0x14>
  }
  return 0;
 406:	4501                	li	a0,0
 408:	a019                	j	40e <memcmp+0x30>
      return *p1 - *p2;
 40a:	40e7853b          	subw	a0,a5,a4
}
 40e:	6422                	ld	s0,8(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret
  return 0;
 414:	4501                	li	a0,0
 416:	bfe5                	j	40e <memcmp+0x30>

0000000000000418 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 420:	00000097          	auipc	ra,0x0
 424:	f62080e7          	jalr	-158(ra) # 382 <memmove>
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret

0000000000000430 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 430:	4885                	li	a7,1
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exit>:
.global exit
exit:
 li a7, SYS_exit
 438:	4889                	li	a7,2
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <wait>:
.global wait
wait:
 li a7, SYS_wait
 440:	488d                	li	a7,3
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 448:	4891                	li	a7,4
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <read>:
.global read
read:
 li a7, SYS_read
 450:	4895                	li	a7,5
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <write>:
.global write
write:
 li a7, SYS_write
 458:	48c1                	li	a7,16
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <close>:
.global close
close:
 li a7, SYS_close
 460:	48d5                	li	a7,21
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <kill>:
.global kill
kill:
 li a7, SYS_kill
 468:	4899                	li	a7,6
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exec>:
.global exec
exec:
 li a7, SYS_exec
 470:	489d                	li	a7,7
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <open>:
.global open
open:
 li a7, SYS_open
 478:	48bd                	li	a7,15
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 480:	48c5                	li	a7,17
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 488:	48c9                	li	a7,18
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 490:	48a1                	li	a7,8
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <link>:
.global link
link:
 li a7, SYS_link
 498:	48cd                	li	a7,19
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a0:	48d1                	li	a7,20
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a8:	48a5                	li	a7,9
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b0:	48a9                	li	a7,10
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b8:	48ad                	li	a7,11
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c0:	48b1                	li	a7,12
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c8:	48b5                	li	a7,13
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d0:	48b9                	li	a7,14
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d8:	1101                	addi	sp,sp,-32
 4da:	ec06                	sd	ra,24(sp)
 4dc:	e822                	sd	s0,16(sp)
 4de:	1000                	addi	s0,sp,32
 4e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e4:	4605                	li	a2,1
 4e6:	fef40593          	addi	a1,s0,-17
 4ea:	00000097          	auipc	ra,0x0
 4ee:	f6e080e7          	jalr	-146(ra) # 458 <write>
}
 4f2:	60e2                	ld	ra,24(sp)
 4f4:	6442                	ld	s0,16(sp)
 4f6:	6105                	addi	sp,sp,32
 4f8:	8082                	ret

00000000000004fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fa:	7139                	addi	sp,sp,-64
 4fc:	fc06                	sd	ra,56(sp)
 4fe:	f822                	sd	s0,48(sp)
 500:	f426                	sd	s1,40(sp)
 502:	f04a                	sd	s2,32(sp)
 504:	ec4e                	sd	s3,24(sp)
 506:	0080                	addi	s0,sp,64
 508:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50a:	c299                	beqz	a3,510 <printint+0x16>
 50c:	0805c863          	bltz	a1,59c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 510:	2581                	sext.w	a1,a1
  neg = 0;
 512:	4881                	li	a7,0
 514:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 518:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 51a:	2601                	sext.w	a2,a2
 51c:	00001517          	auipc	a0,0x1
 520:	8e450513          	addi	a0,a0,-1820 # e00 <digits>
 524:	883a                	mv	a6,a4
 526:	2705                	addiw	a4,a4,1
 528:	02c5f7bb          	remuw	a5,a1,a2
 52c:	1782                	slli	a5,a5,0x20
 52e:	9381                	srli	a5,a5,0x20
 530:	97aa                	add	a5,a5,a0
 532:	0007c783          	lbu	a5,0(a5)
 536:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 53a:	0005879b          	sext.w	a5,a1
 53e:	02c5d5bb          	divuw	a1,a1,a2
 542:	0685                	addi	a3,a3,1
 544:	fec7f0e3          	bgeu	a5,a2,524 <printint+0x2a>
  if(neg)
 548:	00088b63          	beqz	a7,55e <printint+0x64>
    buf[i++] = '-';
 54c:	fd040793          	addi	a5,s0,-48
 550:	973e                	add	a4,a4,a5
 552:	02d00793          	li	a5,45
 556:	fef70823          	sb	a5,-16(a4)
 55a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55e:	02e05863          	blez	a4,58e <printint+0x94>
 562:	fc040793          	addi	a5,s0,-64
 566:	00e78933          	add	s2,a5,a4
 56a:	fff78993          	addi	s3,a5,-1
 56e:	99ba                	add	s3,s3,a4
 570:	377d                	addiw	a4,a4,-1
 572:	1702                	slli	a4,a4,0x20
 574:	9301                	srli	a4,a4,0x20
 576:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57a:	fff94583          	lbu	a1,-1(s2)
 57e:	8526                	mv	a0,s1
 580:	00000097          	auipc	ra,0x0
 584:	f58080e7          	jalr	-168(ra) # 4d8 <putc>
  while(--i >= 0)
 588:	197d                	addi	s2,s2,-1
 58a:	ff3918e3          	bne	s2,s3,57a <printint+0x80>
}
 58e:	70e2                	ld	ra,56(sp)
 590:	7442                	ld	s0,48(sp)
 592:	74a2                	ld	s1,40(sp)
 594:	7902                	ld	s2,32(sp)
 596:	69e2                	ld	s3,24(sp)
 598:	6121                	addi	sp,sp,64
 59a:	8082                	ret
    x = -xx;
 59c:	40b005bb          	negw	a1,a1
    neg = 1;
 5a0:	4885                	li	a7,1
    x = -xx;
 5a2:	bf8d                	j	514 <printint+0x1a>

00000000000005a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a4:	7119                	addi	sp,sp,-128
 5a6:	fc86                	sd	ra,120(sp)
 5a8:	f8a2                	sd	s0,112(sp)
 5aa:	f4a6                	sd	s1,104(sp)
 5ac:	f0ca                	sd	s2,96(sp)
 5ae:	ecce                	sd	s3,88(sp)
 5b0:	e8d2                	sd	s4,80(sp)
 5b2:	e4d6                	sd	s5,72(sp)
 5b4:	e0da                	sd	s6,64(sp)
 5b6:	fc5e                	sd	s7,56(sp)
 5b8:	f862                	sd	s8,48(sp)
 5ba:	f466                	sd	s9,40(sp)
 5bc:	f06a                	sd	s10,32(sp)
 5be:	ec6e                	sd	s11,24(sp)
 5c0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c2:	0005c903          	lbu	s2,0(a1)
 5c6:	18090f63          	beqz	s2,764 <vprintf+0x1c0>
 5ca:	8aaa                	mv	s5,a0
 5cc:	8b32                	mv	s6,a2
 5ce:	00158493          	addi	s1,a1,1
  state = 0;
 5d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d4:	02500a13          	li	s4,37
      if(c == 'd'){
 5d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5dc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5e0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5e4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e8:	00001b97          	auipc	s7,0x1
 5ec:	818b8b93          	addi	s7,s7,-2024 # e00 <digits>
 5f0:	a839                	j	60e <vprintf+0x6a>
        putc(fd, c);
 5f2:	85ca                	mv	a1,s2
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	ee2080e7          	jalr	-286(ra) # 4d8 <putc>
 5fe:	a019                	j	604 <vprintf+0x60>
    } else if(state == '%'){
 600:	01498f63          	beq	s3,s4,61e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 604:	0485                	addi	s1,s1,1
 606:	fff4c903          	lbu	s2,-1(s1)
 60a:	14090d63          	beqz	s2,764 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 60e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 612:	fe0997e3          	bnez	s3,600 <vprintf+0x5c>
      if(c == '%'){
 616:	fd479ee3          	bne	a5,s4,5f2 <vprintf+0x4e>
        state = '%';
 61a:	89be                	mv	s3,a5
 61c:	b7e5                	j	604 <vprintf+0x60>
      if(c == 'd'){
 61e:	05878063          	beq	a5,s8,65e <vprintf+0xba>
      } else if(c == 'l') {
 622:	05978c63          	beq	a5,s9,67a <vprintf+0xd6>
      } else if(c == 'x') {
 626:	07a78863          	beq	a5,s10,696 <vprintf+0xf2>
      } else if(c == 'p') {
 62a:	09b78463          	beq	a5,s11,6b2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 62e:	07300713          	li	a4,115
 632:	0ce78663          	beq	a5,a4,6fe <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 636:	06300713          	li	a4,99
 63a:	0ee78e63          	beq	a5,a4,736 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 63e:	11478863          	beq	a5,s4,74e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 642:	85d2                	mv	a1,s4
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e92080e7          	jalr	-366(ra) # 4d8 <putc>
        putc(fd, c);
 64e:	85ca                	mv	a1,s2
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e86080e7          	jalr	-378(ra) # 4d8 <putc>
      }
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b765                	j	604 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 65e:	008b0913          	addi	s2,s6,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000b2583          	lw	a1,0(s6)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e8e080e7          	jalr	-370(ra) # 4fa <printint>
 674:	8b4a                	mv	s6,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	b771                	j	604 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67a:	008b0913          	addi	s2,s6,8
 67e:	4681                	li	a3,0
 680:	4629                	li	a2,10
 682:	000b2583          	lw	a1,0(s6)
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e72080e7          	jalr	-398(ra) # 4fa <printint>
 690:	8b4a                	mv	s6,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	bf85                	j	604 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 696:	008b0913          	addi	s2,s6,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000b2583          	lw	a1,0(s6)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e56080e7          	jalr	-426(ra) # 4fa <printint>
 6ac:	8b4a                	mv	s6,s2
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bf91                	j	604 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6b2:	008b0793          	addi	a5,s6,8
 6b6:	f8f43423          	sd	a5,-120(s0)
 6ba:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6be:	03000593          	li	a1,48
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e14080e7          	jalr	-492(ra) # 4d8 <putc>
  putc(fd, 'x');
 6cc:	85ea                	mv	a1,s10
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e08080e7          	jalr	-504(ra) # 4d8 <putc>
 6d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	03c9d793          	srli	a5,s3,0x3c
 6de:	97de                	add	a5,a5,s7
 6e0:	0007c583          	lbu	a1,0(a5)
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	df2080e7          	jalr	-526(ra) # 4d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ee:	0992                	slli	s3,s3,0x4
 6f0:	397d                	addiw	s2,s2,-1
 6f2:	fe0914e3          	bnez	s2,6da <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b721                	j	604 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fe:	008b0993          	addi	s3,s6,8
 702:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 706:	02090163          	beqz	s2,728 <vprintf+0x184>
        while(*s != 0){
 70a:	00094583          	lbu	a1,0(s2)
 70e:	c9a1                	beqz	a1,75e <vprintf+0x1ba>
          putc(fd, *s);
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	dc6080e7          	jalr	-570(ra) # 4d8 <putc>
          s++;
 71a:	0905                	addi	s2,s2,1
        while(*s != 0){
 71c:	00094583          	lbu	a1,0(s2)
 720:	f9e5                	bnez	a1,710 <vprintf+0x16c>
        s = va_arg(ap, char*);
 722:	8b4e                	mv	s6,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	bdf9                	j	604 <vprintf+0x60>
          s = "(null)";
 728:	00000917          	auipc	s2,0x0
 72c:	6d090913          	addi	s2,s2,1744 # df8 <thread_assign_task+0xb4>
        while(*s != 0){
 730:	02800593          	li	a1,40
 734:	bff1                	j	710 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 736:	008b0913          	addi	s2,s6,8
 73a:	000b4583          	lbu	a1,0(s6)
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	d98080e7          	jalr	-616(ra) # 4d8 <putc>
 748:	8b4a                	mv	s6,s2
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bd65                	j	604 <vprintf+0x60>
        putc(fd, c);
 74e:	85d2                	mv	a1,s4
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	d86080e7          	jalr	-634(ra) # 4d8 <putc>
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b565                	j	604 <vprintf+0x60>
        s = va_arg(ap, char*);
 75e:	8b4e                	mv	s6,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	b54d                	j	604 <vprintf+0x60>
    }
  }
}
 764:	70e6                	ld	ra,120(sp)
 766:	7446                	ld	s0,112(sp)
 768:	74a6                	ld	s1,104(sp)
 76a:	7906                	ld	s2,96(sp)
 76c:	69e6                	ld	s3,88(sp)
 76e:	6a46                	ld	s4,80(sp)
 770:	6aa6                	ld	s5,72(sp)
 772:	6b06                	ld	s6,64(sp)
 774:	7be2                	ld	s7,56(sp)
 776:	7c42                	ld	s8,48(sp)
 778:	7ca2                	ld	s9,40(sp)
 77a:	7d02                	ld	s10,32(sp)
 77c:	6de2                	ld	s11,24(sp)
 77e:	6109                	addi	sp,sp,128
 780:	8082                	ret

0000000000000782 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 782:	715d                	addi	sp,sp,-80
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	e010                	sd	a2,0(s0)
 78c:	e414                	sd	a3,8(s0)
 78e:	e818                	sd	a4,16(s0)
 790:	ec1c                	sd	a5,24(s0)
 792:	03043023          	sd	a6,32(s0)
 796:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79e:	8622                	mv	a2,s0
 7a0:	00000097          	auipc	ra,0x0
 7a4:	e04080e7          	jalr	-508(ra) # 5a4 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6161                	addi	sp,sp,80
 7ae:	8082                	ret

00000000000007b0 <printf>:

void
printf(const char *fmt, ...)
{
 7b0:	711d                	addi	sp,sp,-96
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e40c                	sd	a1,8(s0)
 7ba:	e810                	sd	a2,16(s0)
 7bc:	ec14                	sd	a3,24(s0)
 7be:	f018                	sd	a4,32(s0)
 7c0:	f41c                	sd	a5,40(s0)
 7c2:	03043823          	sd	a6,48(s0)
 7c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	00840613          	addi	a2,s0,8
 7ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d2:	85aa                	mv	a1,a0
 7d4:	4505                	li	a0,1
 7d6:	00000097          	auipc	ra,0x0
 7da:	dce080e7          	jalr	-562(ra) # 5a4 <vprintf>
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	6125                	addi	sp,sp,96
 7e4:	8082                	ret

00000000000007e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e6:	1141                	addi	sp,sp,-16
 7e8:	e422                	sd	s0,8(sp)
 7ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	00000797          	auipc	a5,0x0
 7f4:	6407b783          	ld	a5,1600(a5) # e30 <freep>
 7f8:	a805                	j	828 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fa:	4618                	lw	a4,8(a2)
 7fc:	9db9                	addw	a1,a1,a4
 7fe:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	6318                	ld	a4,0(a4)
 806:	fee53823          	sd	a4,-16(a0)
 80a:	a091                	j	84e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80c:	ff852703          	lw	a4,-8(a0)
 810:	9e39                	addw	a2,a2,a4
 812:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 814:	ff053703          	ld	a4,-16(a0)
 818:	e398                	sd	a4,0(a5)
 81a:	a099                	j	860 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	6398                	ld	a4,0(a5)
 81e:	00e7e463          	bltu	a5,a4,826 <free+0x40>
 822:	00e6ea63          	bltu	a3,a4,836 <free+0x50>
{
 826:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	fed7fae3          	bgeu	a5,a3,81c <free+0x36>
 82c:	6398                	ld	a4,0(a5)
 82e:	00e6e463          	bltu	a3,a4,836 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	fee7eae3          	bltu	a5,a4,826 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 836:	ff852583          	lw	a1,-8(a0)
 83a:	6390                	ld	a2,0(a5)
 83c:	02059713          	slli	a4,a1,0x20
 840:	9301                	srli	a4,a4,0x20
 842:	0712                	slli	a4,a4,0x4
 844:	9736                	add	a4,a4,a3
 846:	fae60ae3          	beq	a2,a4,7fa <free+0x14>
    bp->s.ptr = p->s.ptr;
 84a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84e:	4790                	lw	a2,8(a5)
 850:	02061713          	slli	a4,a2,0x20
 854:	9301                	srli	a4,a4,0x20
 856:	0712                	slli	a4,a4,0x4
 858:	973e                	add	a4,a4,a5
 85a:	fae689e3          	beq	a3,a4,80c <free+0x26>
  } else
    p->s.ptr = bp;
 85e:	e394                	sd	a3,0(a5)
  freep = p;
 860:	00000717          	auipc	a4,0x0
 864:	5cf73823          	sd	a5,1488(a4) # e30 <freep>
}
 868:	6422                	ld	s0,8(sp)
 86a:	0141                	addi	sp,sp,16
 86c:	8082                	ret

000000000000086e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86e:	7139                	addi	sp,sp,-64
 870:	fc06                	sd	ra,56(sp)
 872:	f822                	sd	s0,48(sp)
 874:	f426                	sd	s1,40(sp)
 876:	f04a                	sd	s2,32(sp)
 878:	ec4e                	sd	s3,24(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
 880:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	02051493          	slli	s1,a0,0x20
 886:	9081                	srli	s1,s1,0x20
 888:	04bd                	addi	s1,s1,15
 88a:	8091                	srli	s1,s1,0x4
 88c:	0014899b          	addiw	s3,s1,1
 890:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 892:	00000517          	auipc	a0,0x0
 896:	59e53503          	ld	a0,1438(a0) # e30 <freep>
 89a:	c515                	beqz	a0,8c6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	02977f63          	bgeu	a4,s1,8de <malloc+0x70>
 8a4:	8a4e                	mv	s4,s3
 8a6:	0009871b          	sext.w	a4,s3
 8aa:	6685                	lui	a3,0x1
 8ac:	00d77363          	bgeu	a4,a3,8b2 <malloc+0x44>
 8b0:	6a05                	lui	s4,0x1
 8b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ba:	00000917          	auipc	s2,0x0
 8be:	57690913          	addi	s2,s2,1398 # e30 <freep>
  if(p == (char*)-1)
 8c2:	5afd                	li	s5,-1
 8c4:	a88d                	j	936 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c6:	00000797          	auipc	a5,0x0
 8ca:	58278793          	addi	a5,a5,1410 # e48 <base>
 8ce:	00000717          	auipc	a4,0x0
 8d2:	56f73123          	sd	a5,1378(a4) # e30 <freep>
 8d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8dc:	b7e1                	j	8a4 <malloc+0x36>
      if(p->s.size == nunits)
 8de:	02e48b63          	beq	s1,a4,914 <malloc+0xa6>
        p->s.size -= nunits;
 8e2:	4137073b          	subw	a4,a4,s3
 8e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e8:	1702                	slli	a4,a4,0x20
 8ea:	9301                	srli	a4,a4,0x20
 8ec:	0712                	slli	a4,a4,0x4
 8ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	52a73e23          	sd	a0,1340(a4) # e30 <freep>
      return (void*)(p + 1);
 8fc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 900:	70e2                	ld	ra,56(sp)
 902:	7442                	ld	s0,48(sp)
 904:	74a2                	ld	s1,40(sp)
 906:	7902                	ld	s2,32(sp)
 908:	69e2                	ld	s3,24(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	6121                	addi	sp,sp,64
 912:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 914:	6398                	ld	a4,0(a5)
 916:	e118                	sd	a4,0(a0)
 918:	bff1                	j	8f4 <malloc+0x86>
  hp->s.size = nu;
 91a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91e:	0541                	addi	a0,a0,16
 920:	00000097          	auipc	ra,0x0
 924:	ec6080e7          	jalr	-314(ra) # 7e6 <free>
  return freep;
 928:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92c:	d971                	beqz	a0,900 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 930:	4798                	lw	a4,8(a5)
 932:	fa9776e3          	bgeu	a4,s1,8de <malloc+0x70>
    if(p == freep)
 936:	00093703          	ld	a4,0(s2)
 93a:	853e                	mv	a0,a5
 93c:	fef719e3          	bne	a4,a5,92e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 940:	8552                	mv	a0,s4
 942:	00000097          	auipc	ra,0x0
 946:	b7e080e7          	jalr	-1154(ra) # 4c0 <sbrk>
  if(p == (char*)-1)
 94a:	fd5518e3          	bne	a0,s5,91a <malloc+0xac>
        return 0;
 94e:	4501                	li	a0,0
 950:	bf45                	j	900 <malloc+0x92>

0000000000000952 <setjmp>:
 952:	e100                	sd	s0,0(a0)
 954:	e504                	sd	s1,8(a0)
 956:	01253823          	sd	s2,16(a0)
 95a:	01353c23          	sd	s3,24(a0)
 95e:	03453023          	sd	s4,32(a0)
 962:	03553423          	sd	s5,40(a0)
 966:	03653823          	sd	s6,48(a0)
 96a:	03753c23          	sd	s7,56(a0)
 96e:	05853023          	sd	s8,64(a0)
 972:	05953423          	sd	s9,72(a0)
 976:	05a53823          	sd	s10,80(a0)
 97a:	05b53c23          	sd	s11,88(a0)
 97e:	06153023          	sd	ra,96(a0)
 982:	06253423          	sd	sp,104(a0)
 986:	4501                	li	a0,0
 988:	8082                	ret

000000000000098a <longjmp>:
 98a:	6100                	ld	s0,0(a0)
 98c:	6504                	ld	s1,8(a0)
 98e:	01053903          	ld	s2,16(a0)
 992:	01853983          	ld	s3,24(a0)
 996:	02053a03          	ld	s4,32(a0)
 99a:	02853a83          	ld	s5,40(a0)
 99e:	03053b03          	ld	s6,48(a0)
 9a2:	03853b83          	ld	s7,56(a0)
 9a6:	04053c03          	ld	s8,64(a0)
 9aa:	04853c83          	ld	s9,72(a0)
 9ae:	05053d03          	ld	s10,80(a0)
 9b2:	05853d83          	ld	s11,88(a0)
 9b6:	06053083          	ld	ra,96(a0)
 9ba:	06853103          	ld	sp,104(a0)
 9be:	c199                	beqz	a1,9c4 <longjmp_1>
 9c0:	852e                	mv	a0,a1
 9c2:	8082                	ret

00000000000009c4 <longjmp_1>:
 9c4:	4505                	li	a0,1
 9c6:	8082                	ret

00000000000009c8 <thread_create>:
static struct task *current_task = NULL;
static int id = 1;
static jmp_buf env_st;
static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
 9c8:	7179                	addi	sp,sp,-48
 9ca:	f406                	sd	ra,40(sp)
 9cc:	f022                	sd	s0,32(sp)
 9ce:	ec26                	sd	s1,24(sp)
 9d0:	e84a                	sd	s2,16(sp)
 9d2:	e44e                	sd	s3,8(sp)
 9d4:	1800                	addi	s0,sp,48
 9d6:	89aa                	mv	s3,a0
 9d8:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
 9da:	0c000513          	li	a0,192
 9de:	00000097          	auipc	ra,0x0
 9e2:	e90080e7          	jalr	-368(ra) # 86e <malloc>
 9e6:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 9e8:	6505                	lui	a0,0x1
 9ea:	80050513          	addi	a0,a0,-2048 # 800 <free+0x1a>
 9ee:	00000097          	auipc	ra,0x0
 9f2:	e80080e7          	jalr	-384(ra) # 86e <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
 9f6:	7f050693          	addi	a3,a0,2032
    t->fp = f;
 9fa:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
 9fe:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
 a02:	00000717          	auipc	a4,0x0
 a06:	41a70713          	addi	a4,a4,1050 # e1c <id>
 a0a:	431c                	lw	a5,0(a4)
 a0c:	0af4a023          	sw	a5,160(s1)
    t->buf_set = 0;
 a10:	0804ac23          	sw	zero,152(s1)
    t->exe = 0;
 a14:	0804ae23          	sw	zero,156(s1)
    t->stack = (void*) new_stack;
 a18:	e888                	sd	a0,16(s1)
    t->stack_p = (void*) new_stack_p;
 a1a:	ec94                	sd	a3,24(s1)
    t->latest_sp = new_stack_p;
 a1c:	f094                	sd	a3,32(s1)
    t->task = NULL;
 a1e:	0a04bc23          	sd	zero,184(s1)
    id++;
 a22:	2785                	addiw	a5,a5,1
 a24:	c31c                	sw	a5,0(a4)
    return t;
}
 a26:	8526                	mv	a0,s1
 a28:	70a2                	ld	ra,40(sp)
 a2a:	7402                	ld	s0,32(sp)
 a2c:	64e2                	ld	s1,24(sp)
 a2e:	6942                	ld	s2,16(sp)
 a30:	69a2                	ld	s3,8(sp)
 a32:	6145                	addi	sp,sp,48
 a34:	8082                	ret

0000000000000a36 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
 a36:	1141                	addi	sp,sp,-16
 a38:	e422                	sd	s0,8(sp)
 a3a:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
 a3c:	00000797          	auipc	a5,0x0
 a40:	4047b783          	ld	a5,1028(a5) # e40 <current_thread>
 a44:	cb89                	beqz	a5,a56 <thread_add_runqueue+0x20>
        t->next = t;
        current_thread = t;
    }
    else{
        // TODO
        struct thread* tmp_previous = current_thread->previous;
 a46:	77d8                	ld	a4,168(a5)
        tmp_previous->next = t;
 a48:	fb48                	sd	a0,176(a4)
        t->previous = tmp_previous;
 a4a:	f558                	sd	a4,168(a0)
        t->next = current_thread;
 a4c:	f95c                	sd	a5,176(a0)
        current_thread->previous = t; 
 a4e:	f7c8                	sd	a0,168(a5)
    }
}
 a50:	6422                	ld	s0,8(sp)
 a52:	0141                	addi	sp,sp,16
 a54:	8082                	ret
        t->previous = t;
 a56:	f548                	sd	a0,168(a0)
        t->next = t;
 a58:	f948                	sd	a0,176(a0)
        current_thread = t;
 a5a:	00000797          	auipc	a5,0x0
 a5e:	3ea7b323          	sd	a0,998(a5) # e40 <current_thread>
 a62:	b7fd                	j	a50 <thread_add_runqueue+0x1a>

0000000000000a64 <schedule>:
            current_thread->fp(current_thread->arg);
            thread_exit();
        }
    }
}
void schedule(void){
 a64:	1141                	addi	sp,sp,-16
 a66:	e422                	sd	s0,8(sp)
 a68:	0800                	addi	s0,sp,16
    // TODO
    current_thread = current_thread->next;
 a6a:	00000797          	auipc	a5,0x0
 a6e:	3d678793          	addi	a5,a5,982 # e40 <current_thread>
 a72:	6398                	ld	a4,0(a5)
 a74:	7b58                	ld	a4,176(a4)
 a76:	e398                	sd	a4,0(a5)
}
 a78:	6422                	ld	s0,8(sp)
 a7a:	0141                	addi	sp,sp,16
 a7c:	8082                	ret

0000000000000a7e <thread_exit>:
void thread_exit(void){
 a7e:	1101                	addi	sp,sp,-32
 a80:	ec06                	sd	ra,24(sp)
 a82:	e822                	sd	s0,16(sp)
 a84:	e426                	sd	s1,8(sp)
 a86:	e04a                	sd	s2,0(sp)
 a88:	1000                	addi	s0,sp,32
    // release all task resource 
    while(current_thread->task){
 a8a:	00000497          	auipc	s1,0x0
 a8e:	3b64b483          	ld	s1,950(s1) # e40 <current_thread>
 a92:	7cc8                	ld	a0,184(s1)
 a94:	c91d                	beqz	a0,aca <thread_exit+0x4c>
 a96:	00000917          	auipc	s2,0x0
 a9a:	3aa90913          	addi	s2,s2,938 # e40 <current_thread>
 a9e:	a811                	j	ab2 <thread_exit+0x34>
        if(current_thread->task->previous){
            struct task *tmp = current_thread->task;
            current_thread->task = current_thread->task->previous;
 aa0:	fcdc                	sd	a5,184(s1)
            free(tmp);
 aa2:	00000097          	auipc	ra,0x0
 aa6:	d44080e7          	jalr	-700(ra) # 7e6 <free>
    while(current_thread->task){
 aaa:	00093483          	ld	s1,0(s2)
 aae:	7cc8                	ld	a0,184(s1)
 ab0:	cd09                	beqz	a0,aca <thread_exit+0x4c>
        if(current_thread->task->previous){
 ab2:	655c                	ld	a5,136(a0)
 ab4:	f7f5                	bnez	a5,aa0 <thread_exit+0x22>
        }
        else{
            free(current_thread->task);
 ab6:	00000097          	auipc	ra,0x0
 aba:	d30080e7          	jalr	-720(ra) # 7e6 <free>
            current_thread->task = NULL;
 abe:	00000497          	auipc	s1,0x0
 ac2:	3824b483          	ld	s1,898(s1) # e40 <current_thread>
 ac6:	0a04bc23          	sd	zero,184(s1)
        }
    }
    
    if(current_thread->next != current_thread){
 aca:	78dc                	ld	a5,176(s1)
 acc:	02978f63          	beq	a5,s1,b0a <thread_exit+0x8c>
        // TODO, there are some threads wating
        struct thread* t = current_thread;
        t->previous->next = t->next;
 ad0:	74d8                	ld	a4,168(s1)
 ad2:	fb5c                	sd	a5,176(a4)
        t->next->previous = t->previous;
 ad4:	74d8                	ld	a4,168(s1)
 ad6:	f7d8                	sd	a4,168(a5)
        current_thread = t->next;
 ad8:	78dc                	ld	a5,176(s1)
 ada:	00000717          	auipc	a4,0x0
 ade:	36f73323          	sd	a5,870(a4) # e40 <current_thread>
        free(t->stack);
 ae2:	6888                	ld	a0,16(s1)
 ae4:	00000097          	auipc	ra,0x0
 ae8:	d02080e7          	jalr	-766(ra) # 7e6 <free>
        free(t);
 aec:	8526                	mv	a0,s1
 aee:	00000097          	auipc	ra,0x0
 af2:	cf8080e7          	jalr	-776(ra) # 7e6 <free>
        dispatch();
 af6:	00000097          	auipc	ra,0x0
 afa:	048080e7          	jalr	72(ra) # b3e <dispatch>
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
 afe:	60e2                	ld	ra,24(sp)
 b00:	6442                	ld	s0,16(sp)
 b02:	64a2                	ld	s1,8(sp)
 b04:	6902                	ld	s2,0(sp)
 b06:	6105                	addi	sp,sp,32
 b08:	8082                	ret
        free(current_thread->stack);
 b0a:	6888                	ld	a0,16(s1)
 b0c:	00000097          	auipc	ra,0x0
 b10:	cda080e7          	jalr	-806(ra) # 7e6 <free>
        free(current_thread);
 b14:	00000497          	auipc	s1,0x0
 b18:	32c48493          	addi	s1,s1,812 # e40 <current_thread>
 b1c:	6088                	ld	a0,0(s1)
 b1e:	00000097          	auipc	ra,0x0
 b22:	cc8080e7          	jalr	-824(ra) # 7e6 <free>
        current_thread = NULL;
 b26:	0004b023          	sd	zero,0(s1)
        longjmp(env_st, 1);
 b2a:	4585                	li	a1,1
 b2c:	00000517          	auipc	a0,0x0
 b30:	32c50513          	addi	a0,a0,812 # e58 <env_st>
 b34:	00000097          	auipc	ra,0x0
 b38:	e56080e7          	jalr	-426(ra) # 98a <longjmp>
}
 b3c:	b7c9                	j	afe <thread_exit+0x80>

0000000000000b3e <dispatch>:
void dispatch(void){
 b3e:	1101                	addi	sp,sp,-32
 b40:	ec06                	sd	ra,24(sp)
 b42:	e822                	sd	s0,16(sp)
 b44:	e426                	sd	s1,8(sp)
 b46:	1000                	addi	s0,sp,32
    if(!current_thread->buf_set){
 b48:	00000797          	auipc	a5,0x0
 b4c:	2f87b783          	ld	a5,760(a5) # e40 <current_thread>
 b50:	0987a783          	lw	a5,152(a5)
 b54:	cbad                	beqz	a5,bc6 <dispatch+0x88>
    if(current_thread->task){
 b56:	00000797          	auipc	a5,0x0
 b5a:	2ea7b783          	ld	a5,746(a5) # e40 <current_thread>
 b5e:	7fc8                	ld	a0,184(a5)
 b60:	c97d                	beqz	a0,c56 <dispatch+0x118>
        if(!current_thread->task->buf_set){
 b62:	08052783          	lw	a5,128(a0)
 b66:	efe9                	bnez	a5,c40 <dispatch+0x102>
            current_task = current_thread->task;
 b68:	00000797          	auipc	a5,0x0
 b6c:	2ca7b823          	sd	a0,720(a5) # e38 <current_task>
            if(setjmp(env_tmp) == 0){
 b70:	00000517          	auipc	a0,0x0
 b74:	35850513          	addi	a0,a0,856 # ec8 <env_tmp>
 b78:	00000097          	auipc	ra,0x0
 b7c:	dda080e7          	jalr	-550(ra) # 952 <setjmp>
 b80:	c151                	beqz	a0,c04 <dispatch+0xc6>
            current_task->buf_set = 1;
 b82:	00000497          	auipc	s1,0x0
 b86:	2b648493          	addi	s1,s1,694 # e38 <current_task>
 b8a:	609c                	ld	a5,0(s1)
 b8c:	4705                	li	a4,1
 b8e:	08e7a023          	sw	a4,128(a5)
            current_task->fp(current_task->arg);
 b92:	6398                	ld	a4,0(a5)
 b94:	6788                	ld	a0,8(a5)
 b96:	9702                	jalr	a4
            current_task = NULL;
 b98:	0004b023          	sd	zero,0(s1)
            if(current_thread->task->previous){
 b9c:	00000797          	auipc	a5,0x0
 ba0:	2a47b783          	ld	a5,676(a5) # e40 <current_thread>
 ba4:	7fc8                	ld	a0,184(a5)
 ba6:	6558                	ld	a4,136(a0)
 ba8:	c349                	beqz	a4,c2a <dispatch+0xec>
                current_thread->task = current_thread->task->previous;
 baa:	ffd8                	sd	a4,184(a5)
                free(tmp);
 bac:	00000097          	auipc	ra,0x0
 bb0:	c3a080e7          	jalr	-966(ra) # 7e6 <free>
            dispatch();
 bb4:	00000097          	auipc	ra,0x0
 bb8:	f8a080e7          	jalr	-118(ra) # b3e <dispatch>
}
 bbc:	60e2                	ld	ra,24(sp)
 bbe:	6442                	ld	s0,16(sp)
 bc0:	64a2                	ld	s1,8(sp)
 bc2:	6105                	addi	sp,sp,32
 bc4:	8082                	ret
        if(setjmp(env_tmp) == 0){
 bc6:	00000517          	auipc	a0,0x0
 bca:	30250513          	addi	a0,a0,770 # ec8 <env_tmp>
 bce:	00000097          	auipc	ra,0x0
 bd2:	d84080e7          	jalr	-636(ra) # 952 <setjmp>
 bd6:	f141                	bnez	a0,b56 <dispatch+0x18>
            env_tmp->sp = (unsigned long)current_thread->stack_p;
 bd8:	00000797          	auipc	a5,0x0
 bdc:	2687b783          	ld	a5,616(a5) # e40 <current_thread>
 be0:	6f98                	ld	a4,24(a5)
 be2:	00000697          	auipc	a3,0x0
 be6:	34e6b723          	sd	a4,846(a3) # f30 <env_tmp+0x68>
            current_thread->buf_set = 1;
 bea:	4705                	li	a4,1
 bec:	08e7ac23          	sw	a4,152(a5)
            longjmp(env_tmp, 1);
 bf0:	4585                	li	a1,1
 bf2:	00000517          	auipc	a0,0x0
 bf6:	2d650513          	addi	a0,a0,726 # ec8 <env_tmp>
 bfa:	00000097          	auipc	ra,0x0
 bfe:	d90080e7          	jalr	-624(ra) # 98a <longjmp>
 c02:	bf91                	j	b56 <dispatch+0x18>
                env_tmp->sp = current_thread->latest_sp;
 c04:	00000797          	auipc	a5,0x0
 c08:	23c7b783          	ld	a5,572(a5) # e40 <current_thread>
 c0c:	739c                	ld	a5,32(a5)
 c0e:	00000717          	auipc	a4,0x0
 c12:	32f73123          	sd	a5,802(a4) # f30 <env_tmp+0x68>
                longjmp(env_tmp, 1);
 c16:	4585                	li	a1,1
 c18:	00000517          	auipc	a0,0x0
 c1c:	2b050513          	addi	a0,a0,688 # ec8 <env_tmp>
 c20:	00000097          	auipc	ra,0x0
 c24:	d6a080e7          	jalr	-662(ra) # 98a <longjmp>
 c28:	bfa9                	j	b82 <dispatch+0x44>
                free(current_thread->task);
 c2a:	00000097          	auipc	ra,0x0
 c2e:	bbc080e7          	jalr	-1092(ra) # 7e6 <free>
                current_thread->task = NULL;
 c32:	00000797          	auipc	a5,0x0
 c36:	20e7b783          	ld	a5,526(a5) # e40 <current_thread>
 c3a:	0a07bc23          	sd	zero,184(a5)
 c3e:	bf9d                	j	bb4 <dispatch+0x76>
            current_task = current_thread->task;
 c40:	00000797          	auipc	a5,0x0
 c44:	1ea7bc23          	sd	a0,504(a5) # e38 <current_task>
            longjmp(current_thread->task->env, 1);
 c48:	4585                	li	a1,1
 c4a:	0541                	addi	a0,a0,16
 c4c:	00000097          	auipc	ra,0x0
 c50:	d3e080e7          	jalr	-706(ra) # 98a <longjmp>
 c54:	b7a5                	j	bbc <dispatch+0x7e>
        if(current_thread->exe){
 c56:	09c7a703          	lw	a4,156(a5)
 c5a:	e305                	bnez	a4,c7a <dispatch+0x13c>
            current_task = NULL;
 c5c:	00000717          	auipc	a4,0x0
 c60:	1c073e23          	sd	zero,476(a4) # e38 <current_task>
            current_thread->exe = 1;
 c64:	4705                	li	a4,1
 c66:	08e7ae23          	sw	a4,156(a5)
            current_thread->fp(current_thread->arg);
 c6a:	6398                	ld	a4,0(a5)
 c6c:	6788                	ld	a0,8(a5)
 c6e:	9702                	jalr	a4
            thread_exit();
 c70:	00000097          	auipc	ra,0x0
 c74:	e0e080e7          	jalr	-498(ra) # a7e <thread_exit>
}
 c78:	b791                	j	bbc <dispatch+0x7e>
            current_task = NULL;
 c7a:	00000717          	auipc	a4,0x0
 c7e:	1a073f23          	sd	zero,446(a4) # e38 <current_task>
            longjmp(current_thread->env, 1);
 c82:	4585                	li	a1,1
 c84:	02878513          	addi	a0,a5,40
 c88:	00000097          	auipc	ra,0x0
 c8c:	d02080e7          	jalr	-766(ra) # 98a <longjmp>
 c90:	b735                	j	bbc <dispatch+0x7e>

0000000000000c92 <thread_yield>:
void thread_yield(void){
 c92:	1141                	addi	sp,sp,-16
 c94:	e406                	sd	ra,8(sp)
 c96:	e022                	sd	s0,0(sp)
 c98:	0800                	addi	s0,sp,16
    if(current_task){
 c9a:	00000517          	auipc	a0,0x0
 c9e:	19e53503          	ld	a0,414(a0) # e38 <current_task>
 ca2:	c129                	beqz	a0,ce4 <thread_yield+0x52>
        if(setjmp(current_task->env) == 0){
 ca4:	0541                	addi	a0,a0,16
 ca6:	00000097          	auipc	ra,0x0
 caa:	cac080e7          	jalr	-852(ra) # 952 <setjmp>
 cae:	c509                	beqz	a0,cb8 <thread_yield+0x26>
}
 cb0:	60a2                	ld	ra,8(sp)
 cb2:	6402                	ld	s0,0(sp)
 cb4:	0141                	addi	sp,sp,16
 cb6:	8082                	ret
            current_thread->latest_sp = current_task->env->sp;
 cb8:	00000797          	auipc	a5,0x0
 cbc:	18078793          	addi	a5,a5,384 # e38 <current_task>
 cc0:	6398                	ld	a4,0(a5)
 cc2:	7f34                	ld	a3,120(a4)
 cc4:	00000717          	auipc	a4,0x0
 cc8:	17c73703          	ld	a4,380(a4) # e40 <current_thread>
 ccc:	f314                	sd	a3,32(a4)
            current_task = NULL;
 cce:	0007b023          	sd	zero,0(a5)
            schedule();
 cd2:	00000097          	auipc	ra,0x0
 cd6:	d92080e7          	jalr	-622(ra) # a64 <schedule>
            dispatch();
 cda:	00000097          	auipc	ra,0x0
 cde:	e64080e7          	jalr	-412(ra) # b3e <dispatch>
 ce2:	b7f9                	j	cb0 <thread_yield+0x1e>
        if(setjmp(current_thread->env) == 0){
 ce4:	00000517          	auipc	a0,0x0
 ce8:	15c53503          	ld	a0,348(a0) # e40 <current_thread>
 cec:	02850513          	addi	a0,a0,40
 cf0:	00000097          	auipc	ra,0x0
 cf4:	c62080e7          	jalr	-926(ra) # 952 <setjmp>
 cf8:	fd45                	bnez	a0,cb0 <thread_yield+0x1e>
            current_thread->latest_sp = current_thread->env->sp;
 cfa:	00000797          	auipc	a5,0x0
 cfe:	1467b783          	ld	a5,326(a5) # e40 <current_thread>
 d02:	6bd8                	ld	a4,144(a5)
 d04:	f398                	sd	a4,32(a5)
            schedule();
 d06:	00000097          	auipc	ra,0x0
 d0a:	d5e080e7          	jalr	-674(ra) # a64 <schedule>
            dispatch();
 d0e:	00000097          	auipc	ra,0x0
 d12:	e30080e7          	jalr	-464(ra) # b3e <dispatch>
}
 d16:	bf69                	j	cb0 <thread_yield+0x1e>

0000000000000d18 <thread_start_threading>:
void thread_start_threading(void){
 d18:	1141                	addi	sp,sp,-16
 d1a:	e406                	sd	ra,8(sp)
 d1c:	e022                	sd	s0,0(sp)
 d1e:	0800                	addi	s0,sp,16
    // TODO
    if(setjmp(env_st) == 0){
 d20:	00000517          	auipc	a0,0x0
 d24:	13850513          	addi	a0,a0,312 # e58 <env_st>
 d28:	00000097          	auipc	ra,0x0
 d2c:	c2a080e7          	jalr	-982(ra) # 952 <setjmp>
 d30:	c509                	beqz	a0,d3a <thread_start_threading+0x22>
        dispatch();
    }
    return;
}
 d32:	60a2                	ld	ra,8(sp)
 d34:	6402                	ld	s0,0(sp)
 d36:	0141                	addi	sp,sp,16
 d38:	8082                	ret
        dispatch();
 d3a:	00000097          	auipc	ra,0x0
 d3e:	e04080e7          	jalr	-508(ra) # b3e <dispatch>
    return;
 d42:	bfc5                	j	d32 <thread_start_threading+0x1a>

0000000000000d44 <thread_assign_task>:

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
 d44:	7179                	addi	sp,sp,-48
 d46:	f406                	sd	ra,40(sp)
 d48:	f022                	sd	s0,32(sp)
 d4a:	ec26                	sd	s1,24(sp)
 d4c:	e84a                	sd	s2,16(sp)
 d4e:	e44e                	sd	s3,8(sp)
 d50:	1800                	addi	s0,sp,48
 d52:	84aa                	mv	s1,a0
 d54:	89ae                	mv	s3,a1
 d56:	8932                	mv	s2,a2
    // TODO
    // test whether the thread is existed
    struct thread *tmp = current_thread;
 d58:	00000717          	auipc	a4,0x0
 d5c:	0e873703          	ld	a4,232(a4) # e40 <current_thread>
 d60:	87ba                	mv	a5,a4
    int existed = 0;
    do{
        if(tmp == t) {
 d62:	00978e63          	beq	a5,s1,d7e <thread_assign_task+0x3a>
            existed = 1;
            break;
        }
        tmp = tmp->next;
 d66:	7bdc                	ld	a5,176(a5)
    } while( tmp != current_thread);
 d68:	fef71de3          	bne	a4,a5,d62 <thread_assign_task+0x1e>
    }
    else{   
        T->previous = t->task;
        t->task = T;
    }
}
 d6c:	70a2                	ld	ra,40(sp)
 d6e:	7402                	ld	s0,32(sp)
 d70:	64e2                	ld	s1,24(sp)
 d72:	6942                	ld	s2,16(sp)
 d74:	69a2                	ld	s3,8(sp)
 d76:	6145                	addi	sp,sp,48
 d78:	8082                	ret
        t->task = T;
 d7a:	fcc8                	sd	a0,184(s1)
 d7c:	bfc5                	j	d6c <thread_assign_task+0x28>
    struct task *T = (struct task*)malloc(sizeof(struct task));
 d7e:	09000513          	li	a0,144
 d82:	00000097          	auipc	ra,0x0
 d86:	aec080e7          	jalr	-1300(ra) # 86e <malloc>
    T->fp = f;
 d8a:	01353023          	sd	s3,0(a0)
    T->arg = arg;
 d8e:	01253423          	sd	s2,8(a0)
    T->buf_set = 0;
 d92:	08052023          	sw	zero,128(a0)
    T->previous = NULL;
 d96:	08053423          	sd	zero,136(a0)
    if(t->task == NULL){
 d9a:	7cdc                	ld	a5,184(s1)
 d9c:	dff9                	beqz	a5,d7a <thread_assign_task+0x36>
        T->previous = t->task;
 d9e:	e55c                	sd	a5,136(a0)
        t->task = T;
 da0:	fcc8                	sd	a0,184(s1)
 da2:	b7e9                	j	d6c <thread_assign_task+0x28>
