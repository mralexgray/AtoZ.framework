//
//  AtoZObjC.h
//  AtoZObjC
//
//  Created by Alex Gray on 6/4/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AtoZObjC : NSObject	@end
#define NSN NSNumber
#define UDEFSCTL	 	[NSUserDefaultsController sharedUserDefaultsController]
#define CONTINUOUS 	NSContinuouslyUpdatesValueBindingOption:@(YES)
#define CABA 	CABasicAnimation
#define CABD 	CABlockDelegate
#define NSOV 	NSOutlineView	
#define NSTC 	NSTableColumn	
#define NSI 	NSInteger	
#define AZN 	AZNode	
#define NSD 	NSDictionary
#define NSMA 	NSMutableArray
#define NSA		NSArray
#define NSIMG	NSImage
#define NSS		NSString
#define NSW		NSWindow
#define NSNOT	NSNotification
#define FM 		NSFileManager.defaultManager
#define UDEFS 	NSUserDefaults.standardUserDefaults
#define PINFO	NSProcessInfo.processInfo
#define AZF AZFile
#define cgRANDOMCOLOR [NSColor colorWithCalibratedRed:(float)random()/RAND_MAX green:(float) random()/RAND_MAX blue:(float) random()/RAND_MAX alpha:1.0f].CGColor
#define NSC NSColor
#define WHITE(x,z) [NSC colorWithDeviceWhite:x alpha:z]


#import <THObserversAndBinders/THObserversAndBinders.h>
#import "AtoZNodeProtocol.h"
#import "CABlockDelegate.h"
#import "DefinitionController.h"




NS_INLINE NSString* runCommand(NSString* c) {
	NSString* outP;	FILE *read_fp;	char buffer[BUFSIZ + 1];	int chars_read;
	memset(buffer, '\0', sizeof(buffer));
	read_fp = popen(c.UTF8String, "r");
	if (read_fp != NULL) {
		chars_read = (int)fread(buffer, sizeof(char), BUFSIZ, read_fp);
	   		if (chars_read > 0) outP = [NSString stringWithUTF8String:buffer];
		pclose(read_fp);
	}	
	return outP;
}

#define PLAYMACRO(name,path) \
 NS_INLINE void play##name (void){ fprintf(stderr,"%s", "##path\""); runCommand (@"afplay ##path"); } 

PLAYMACRO(Chirp, /System/Library/PrivateFrameworks/ShareKit.framework/Versions/A/PlugIns/Twitter.sharingservice/Contents/Resources/tweet_sent.caf)

NS_INLINE void playTrumpet(void){ runCommand(@"afplay \"/System/Library/Frameworks/GameKit.framework/Versions/A/Resources/GKInvite.aif\""); }


//NS_INLINE void playChirp  (void){ runCommand(@"afplay \"/System/Library/PrivateFrameworks/ShareKit.framework/Versions/A/PlugIns/Twitter.sharingservice/Contents/Resources/tweet_sent.caf\""); }
//NS_INLINE void playSound  (void){ runCommand(@"afplay \"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/accessibility/Sticky Keys ON.aif\"");}

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
