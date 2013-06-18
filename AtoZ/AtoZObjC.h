//
//  AtoZObjC.h
//  AtoZObjC
//
//  Created by Alex Gray on 6/4/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_INLINE NSString* runCommand(NSString* c) {
//	NSString* outP;	FILE *read_fp;	char buffer[BUFSIZ + 1];	int chars_read;
//	memset(buffer, '\0', sizeof(buffer));
//	read_fp = popen(c.UTF8String, "r");
//	if (read_fp != NULL) {
//		chars_read = (int)fread(buffer, sizeof(char), BUFSIZ, read_fp);
//	   		if (chars_read > 0) outP = [NSString stringWithUTF8String:buffer];
//		pclose(read_fp);
//	}	
//	return outP;
//}


@interface AtoZObjC : NSObject	
+ (NSString*) runCommand:(NSString*)command;
+      (void) listClasses;
@end

/*
#define NSN NSNumber

#define CABA 	CABasicAnimation
#define NSOV 	NSOutlineView	
#define NSTC 	NSTableColumn	
#define NSI 	NSInteger	
	
#define NSD 	NSDictionary
#define NSMA 	NSMutableArray
#define NSA		NSArray
#define NSIMG	NSImage
#define NSS		NSString
#define NSW		NSWindow
#define NSNOT	NSNotification
#define cgRANDOMCOLOR [NSColor colorWithCalibratedRed:(float)random()/RAND_MAX green:(float) random()/RAND_MAX blue:(float) random()/RAND_MAX alpha:1.0f].CGColor
#define NSC NSColor
#define WHITE(x,z) [NSC colorWithDeviceWhite:x alpha:z]
*/
//#import <THObserversAndBinders/THObserversAndBinders.h>
//#import "AtoZNodeProtocol.h"
//#import "CABlockDelegate.h"
//#import "DefinitionController.h"






//#import <QuartzCore/QuartzCore.h>
 
/*
// Block to call when animation fails
// Delegate method called by CAAnimation at start of animation @param theAnimation animation which issued the callback.
- (void)animationDidStart:(CAAnimation *)theAnimation;
 
// Delegate method called by CAAnimation at end of animation @param theAnimation animation which issued the callback.  @param finished BOOL indicating whether animation succeeded or failed.
- (void)animationDidStop:(CAAnimation *)theAnimation 
                finished:(BOOL)flag;
@end

// Block to call when animation is successful
@property (nonatomic, strong) 
    void(^blockOnAnimationSucceeded)(void);
 

*/
