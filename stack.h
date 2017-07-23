#ifndef STACK_H_
#define STACK_H_

#define STACK_SZ 1024

typedef struct stack {
    int position;
    int stack[STACK_SZ];
} STACK;

void stack_init();
void stack_push(int x);
int stack_pop();
int stack_peek();

#endif
