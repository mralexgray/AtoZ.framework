
#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

int add(int a, int b){ return (a+b); }
int (*function)(int a, int b) = NULL;

int main (int argc, const char * argv[]) {
	@autoreleasepool {

NSPointerArray *pointerArray = [NSPointerArray pointerArrayWithWeakObjects];
[pointerArray addPointer: &add];

function = [pointerArray pointerAtIndex:0];
int a,b;
a = 2;
b = 5;
NSLog(@"a = %d, b = %d, function(a,b) = %d", a, b, (*function)(a,b) );

}
return 0;
}
