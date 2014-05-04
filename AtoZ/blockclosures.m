#import <AtoZ/AtoZ.h>
int main(int argc, char *argv[]) {
    @autoreleasepool {

        typedef int(^Block)(void);

        void *p0, *p1;

        Block blockOnStack[3];
        Block blockOnHeap [3];

        for (int i=0; i<3; i++) {
            int int1 = 5;
            int int2 = 10;
            Block closure = ^{ return i; };

            blockOnStack[i] =             closure;
            blockOnHeap [i] = Block_copy( closure );

            printf("closure pointer:     %p\n",                blockOnStack[i] );
            printf("Block_copy pointer:                 %p\n", blockOnHeap [i] );
        }

        printf("\nExecuting blocks from the stack\n");
        for (int i = 0; i < 3; i++) {
            printf("pointer b[%d]: %p\n", i, blockOnStack[i]   );
            printf("Execute b[%d]: %d\n", i, blockOnStack[i]() );
        }
        printf("\nExecuting blocks from the heap\n");
        for (int i = 0; i < 3; i++) {
            printf("pointer b[%d]: %p\n", i, blockOnHeap[i]   );
            printf("Execute b[%d]: %d\n", i, blockOnHeap[i]() );
        }
        printf("\nC blocks\n");
        // "normal" C block scope 1
        {
            int blockInt0 = 5;
            p0 = &blockInt0;
        }

        // "normal" block scope 2
        {
            int blockInt1 = 10;
            p1 = &blockInt1;
        }

        printf("p0 = %p\np1 = %p\n", p0, p1);

        return 0;
    }