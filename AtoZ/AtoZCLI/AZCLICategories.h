//
//  AZCLICategories.h
//  AtoZ
//
//  Created by Alex Gray on 4/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>
@interface NSWorkspace (OPEN)

- (IBAction) openInTerminal:(id)x;
@end


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
NS_INLINE NSD * AZObjCVars (void) { return @{

/** CHIC! FIERCE! */

	@"OBJC_HELP"									: @"describe available environment variables",
	@"OBJC_PRINT_OPTIONS"						: @" list which options are set",
	@"OBJC_PRINT_IMAGES"							: @"log image and library names as they are loaded",
	@"OBJC_PRINT_LOAD_METHODS"					: @"log calls to class and category +load methods",
	@"OBJC_PRINT_INITIALIZE_METHODS"			: @"log calls to class +initialize methods",
	@"OBJC_PRINT_RESOLVED_METHODS"			: @"log methods created by +resolveClassMethod: and +resolveInstanceMethod:",
	@"OBJC_PRINT_CLASS_SETUP"					: @"log progress of class and category setup",
	@"OBJC_PRINT_PROTOCOL_SETUP"				: @"log progress of protocol setup",
	@"OBJC_PRINT_IVAR_SETUP"					: @"log processing of non-fragile ivars",
	@"OBJC_PRINT_VTABLE_SETUP"					: @"log processing of class vtables",
	@"OBJC_PRINT_VTABLE_IMAGES"				: @"print vtable images showing overridden methods",
	@"OBJC_PRINT_CACHE_SETUP"					: @"log processing of method caches",
	@"OBJC_PRINT_FUTURE_CLASSES"				: @"log use of future classes for toll-free bridging",
	@"OBJC_PRINT_GC"								: @"log some GC operations",
	@"OBJC_PRINT_PREOPTIMIZATION"				: @"log preoptimization courtesy of dyld shared cache",
	@"OBJC_PRINT_CXX_CTORS"						: @"log calls to C++ ctors and dtors for instance variables",
	@"OBJC_PRINT_EXCEPTIONS"					: @"log exception handling",
	@"OBJC_PRINT_EXCEPTION_THROW"				: @"log backtrace of every objc_exception_throw()",
	@"OBJC_PRINT_ALT_HANDLERS"					: @"log processing of exception alt handlers",
	@"  "			: @"log methods replaced by category implementations",
	@"OBJC_PRINT_DEPRECATION_WARNINGS"		: @"warn about calls to deprecated runtime functions",
	@"OBJC_PRINT_POOL_HIGHWATER"				: @"log high-water marks for autorelease pools",
	@"OBJC_PRINT_CUSTOM_RR"						: @"log classes with un-optimized custom retain/release methods",
	@"OBJC_PRINT_CUSTOM_AWZ"					: @"log classes with un-optimized custom allocWithZone methods",
	@"OBJC_DEBUG_UNLOAD"							: @"warn about poorly-behaving bundles when unloaded",
	@"OBJC_DEBUG_FRAGILE_SUPERCLASSES"		: @"warn about subclasses that may have been broken by subsequent changes to superclasses",
	@"OBJC_DEBUG_FINALIZERS"					: @"warn about classes that implement -dealloc but not -finalize",
	@"OBJC_DEBUG_NIL_SYNC"						: @"warn about @synchronized(nil), which does no synchronization",
	@"OBJC_DEBUG_NONFRAGILE_IVARS"			: @"capriciously rearrange non-fragile ivars",
	@"OBJC_DEBUG_ALT_HANDLERS"					: @"record more info about bad alt handler use",
	@"OBJC_DEBUG_MISSING_POOLS"				: @"warn about autorelease with no pool in place, which may be a leak",
	@"OBJC_USE_INTERNAL_ZONE"					: @"allocate runtime data in a dedicated malloc zone",
	@"OBJC_DISABLE_GC"							: @"force GC OFF, even if the executable wants it on",
	@"OBJC_DISABLE_VTABLES"						: @"disable vtable dispatch",
	@"OBJC_DISABLE_PREOPTIMIZATION"			: @"disable preoptimization courtesy of dyld shared cache",
	@"OBJC_DISABLE_TAGGED_POINTERS"			: @"disable tagged pointer optimization of NSNumber et al."	};
}

//_RO NSA 	*names, *colors;
//_RONSC 	*next;
//@property (STR) NSS	*name;
//
//- (id) objectAtIndexedSubscript:(NSUI)idx;
//
//+ (instancetype) instanceWithListNamed:(NSS*)listName;
//+ (instancetype) instanceWithColorList:(NSCL*)list;
//+ (instancetype) instanceWithNames:(NSA*)names;
//+ (instancetype) instanceWithColors:(NSA*)names;
//+ (NSS*) cliMenuFor:(NSA*)items starting:(NSUI)idx palette:(NSA*)p;


// send a simple program to clang using a GCD task
//- (void) rovideStdin:(NSFileHandle *)stdinHandle;
// read the output from clang and dump to console
//- (void) getData:(NSNotification *)notifcation;
// invoke clang using an NSTask, reading output via notifications and providing input via an async GCD task
//- (void) pplicationDidFinishLaunching:(NSNotification *)aNotification;
