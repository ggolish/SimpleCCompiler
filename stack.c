#include "stack.h"

STACK s;

void stack_init()
{
    s.position = 0;
}

void stack_push(int x)
{
    s.stack[s.position++] = x;
}

int stack_pop()
{
    return s.stack[--s.position];
}

int stack_peek()
{
    return s.stack[s.position - 1];
}
