typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long uint64;

#define PG_BUF_SIZE 8

typedef struct lru {
	uint32 size;
	uint64 bucket[PG_BUF_SIZE];
} lru_t;

void lru_init(lru_t *lru);
int lru_push(lru_t *lru, uint64 e);
uint64 lru_pop(lru_t *lru, int idx);
int lru_empty(lru_t *lru);
int lru_full(lru_t *lru);
int lru_clear(lru_t *lru);
int lru_find(lru_t *lru, uint64 e);
