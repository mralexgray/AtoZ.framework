

BOOL flag = YES;
NSLog(flag ? @"Yes" : @"No");
?: is the ternary conditional operator of the form:
condition ? result_if_true : result_if_false

#pragma - Log Functions

#ifdef DEBUG
#	define CWPrintClassAndMethod() NSLog(@"%s%i:\n",__PRETTY_FUNCTION__,__LINE__)
#	define CWDebugLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
#else
#	define CWPrintClassAndMethod() /**/
#	define CWDebugLog(args...) /**/
#endif

#define CWLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
#define CWDebugLocationString() [NSString stringWithFormat:@"%s[%i]",__PRETTY_FUNCTION__,__LINE__]

#define nilease(A) [A release]; A = nil

#define $affectors(A,...) +(NSSet *)keyPathsForValuesAffecting##A { static NSSet *re = nil; \
if (!re) { re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; } return re; }


 static NSA* colors;  colors = colors ?: NSC.randomPalette;
 static NSUI idx = 0;
 va_list   argList;
 va_start (argList, format);
 NSS *path  	= [$UTF8(file) lastPathComponent];
 NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
 //	NSS *justinfo = $(@"[%s]:%i",path.UTF8String, lineNumber);
 //	NSS *info   = [NSString stringWithFormat:@"word:%-11s rank:%u", [word UTF8String], rank];
 NSS *info 	= $( XCODE_COLORS_ESCAPE @"fg82,82,82;" @"  [%s]" XCODE_COLORS_RESET
 XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i" XCODE_COLORS_RESET	, path.UTF8String, lineNumber);
 int max 			= 130;
 int cutTo			= 22;
 BOOL longer 	= mess.length > max;
 NSC *c = [colors normal:idx];
 NSS *cs = $(@"%i%i%i",(int)c.redComponent, (int)c.greenComponent, (int)c.blueComponent); idx++;
 NSS* nextLine 	= longer ? $(XCODE_COLORS_ESCAPE @"fg%@;" XCODE_COLORS_RESET @"\n\t%@\n", cs, [mess substringFromIndex:max - cutTo]) : @"\n";
 mess 				= longer ? [mess substringToIndex:max - cutTo] : mess;
 int add = max - mess.length - cutTo;
 if (add > 0) {
 NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
 info = [pad stringByAppendingString:info];
 }
 NSS *toLog 	= $(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET @"%@%@", cs, mess, info, nextLine);
 fprintf ( stderr, "%s", toLog.UTF8String);//[%s]:%i %s \n", [path UTF8String], lineNumber, [message UTF8String] );
 va_end  (argList);


	NSS *toLog 	= $( XCODE_COLORS_RESET	@"%s" XCODE_COLORS_ESCAPE @"fg82,82,82;" @"%-70s[%s]" XCODE_COLORS_RESET
									XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i\n" XCODE_COLORS_RESET	,
									mess.UTF8String, "", path.UTF8String, lineNumber);

	NSLog(XCODE_COLORS_ESCAPE @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
	NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
			XCODE_COLORS_ESCAPE @"bg220,0,0;"
			@"Blue text on red background"
//			XCODE_COLORS_RESET);

 if ( [[NSApplication sharedApplication] delegate] ) {
 id appD = [[NSApplication sharedApplication] delegate];
 //		fprintf ( stderr, "%s", [[appD description]UTF8String] );
 if ( [(NSObject*)appD respondsToSelector:NSSelectorFromString(@"stdOutView")]) {
 NSTextView *tv 	= ((NSTextView*)[appD valueForKey:@"stdOutView"]);
 if (tv) [tv autoScrollText:toLog];
 }
 }

 $(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])	]
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
}


#define AZTransition(duration, type, subtype) CATransition *transition = [CATransition animation];
[transition setDuration:1.0];
[transition setType:kCATransitionPush];
[transition setSubtype:kCATransitionFromLeft];
extern NSArray* AZConstraintEdgeExcept(AZCOn attr, rel, scale, off) \
[NSArray arrayWithArray:@[
AZConstRelSuper( kCAConstraintMaxX ),
AZConstRelSuper( kCAConstraintMinX ),
AZConstRelSuper( kCAConstraintWidth),
AZConstRelSuper( kCAConstraintMinY ),
AZConstRelSuperScaleOff(kCAConstraintHeight, .2, 0),

#define AZConstraint(attr, rel) \
[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]
@property (nonatomic, assign) <\#type\#> <\#name\#>;
 AZConst(<\#CAConstraintAttribute\#>, <#\NSString\#>);
 AZConst(<#CAConstraintAttribute#>, <#NSString*#>);
#import "AtoZiTunes.h"

// Sweetness vs. longwindedness
//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

//  Weak delegate support
#ifndef ah_weak
#import <Availability.h>
#if (__has_feature(objc_arc)) && \
((defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) || \
(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_7))
#define ah_weak weak
#define __ah_weak __weak
#else
#define ah_weak unsafe_unretained
#define __ah_weak __unsafe_unretained
#endif
#endif
//  ARC Helper ends


#define AZRelease(value) \
if ( value ) { \
[value release]; \
value = nil; \
}

#define AZAssign(oldValue,newValue) \
[ newValue retain ]; \
AZRelease (oldValue); \
oldValue = newValue;
