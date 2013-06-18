//
//  AZCLICategories.h
//  AtoZ
//
//  Created by Alex Gray on 4/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"


typedef 	void (^runBlock)();
#define	CurrentIMP 	__CurrentIMP 					(__PRETTY_FUNCTION__,      _cmd)
NS_INLINE 		 IMP 	__CurrentIMP 					(const char *info,     SEL _cmd)	{ // static 	inline

	__block IMP imp = NULL;
  	return    info[0]	!= '-' 		 || 
				 info[0] != '+' ? imp : ^{		NSS *tmp, *clsName;  Class thisCls;
		
		tmp 		= $UTF8(info+2);
		clsName 	= [tmp substringToIndex:[tmp rangeOfString:@" "].location];
		thisCls 	= NSClassFromString ( clsName );
		
		if (thisCls   != nil) {		Method m 	= NULL;
			m 		= info[0] == '+' 	? class_getClassMethod(thisCls, _cmd) 	: class_getInstanceMethod(thisCls, _cmd);
			imp 	= m != NULL 		? method_getImplementation(m) 			: imp;
		}
		return imp;	//	NSLog(@"IMP%@", (__bridge void**)imp);
	}();
}
NS_INLINE void	AZCLogFormatWithArguments 	(const char *fmt,  va_list args)	{ vfprintf(stderr,fmt,args); fflush(stderr); }
NS_INLINE void	             AZCLogFormat	(const char *fmt,...) 				{ va_list args; va_start(args,fmt);	
																									  AZCLogFormatWithArguments(fmt,args); va_end(args);	}


//@property (RONLY) NSA 	*names, *colors;
//@property (RONLY) NSC 	*next;
//@property (STRNG) NSS	*name;
//
//- (id) objectAtIndexedSubscript:(NSUI)idx;
//
//+ (instancetype) instanceWithListNamed:(NSS*)listName;
//+ (instancetype) instanceWithColorList:(NSCL*)list;
//+ (instancetype) instanceWithNames:(NSA*)names;
//+ (instancetype) instanceWithColors:(NSA*)names;
//+ (NSS*) cliMenuFor:(NSA*)items starting:(NSUI)idx palette:(NSA*)p;


// send a simple program to clang using a GCD task
//- (void)provideStdin:(NSFileHandle *)stdinHandle;
// read the output from clang and dump to console
//- (void) getData:(NSNotification *)notifcation;
// invoke clang using an NSTask, reading output via notifications and providing input via an async GCD task
//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
