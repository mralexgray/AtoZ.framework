/*  ___DIRECTORY___/___FILENAME___  /  ___PROJECTNAME___ Created: ___DATE___.  © ___YEAR___ ___ORGANIZATIONNAME___  */

#import "___FILEBASENAME___.h"
#import <AtoZ/AtoZ.h>

@implementation ___FILEBASENAMEASIDENTIFIER___

static ___FILEBASENAMEASIDENTIFIER___ *sharedInstance = nil;

+ (___FILEBASENAMEASIDENTIFIER___ *)shared___FILEBASENAMEASIDENTIFIER___ {
	if (sharedInstance == nil) {
		sharedInstance = [[super allocWithZone:NULL] init];
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	return [[self shared___FILEBASENAMEASIDENTIFIER___] retain];
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

@end
