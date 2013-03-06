#include <stdio.h>
#include <sys/types.h>
#include <sys/resource.h>
#import <Foundation/Foundation.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {


//	extern int __getpriority(int, int);

//	int whatgetpriority(int which, int who)
//	{
//	  int result = __getpriority(which, who);

//	  return ( result < 0 ) ? result : 20-result;
//	}
//

+ (NSI) getPriorityFromPath: (NSS*)path {
	int which = PRIO_PROCESS;
	id_t pid;
	int ret;

	pid = 46152;// getpid();
	ret = getpriority(which, pid);
//	NSInteger i = getpriority(0, 46152);
	NSLog(@"%i", ret);


		
	}
}