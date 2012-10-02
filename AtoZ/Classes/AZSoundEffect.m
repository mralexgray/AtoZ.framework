//
//  AZSoundEffect.m
//  AtoZ
//
//  Created by Alex Gray on 10/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZSoundEffect.h"
#import <AudioToolbox/AudioServices.h>
#import "AtoZ.h"

@implementation AZSoundEffect {
	SystemSoundID soundID;
}

- (id)initWithSoundNamed:(NSString *)filename
{
	if ((self = [super init])) {
		NSURL *fileURL = [[[AtoZ sharedInstance]bundle] URLForResource:filename withExtension:nil];
		if (fileURL != nil) {
			SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
			if (error == kAudioServicesNoError) soundID = theSoundID;
		}
	}
	return self;
}

- (void)dealloc {	AudioServicesDisposeSystemSoundID(soundID); }

- (void)play { 	AudioServicesPlaySystemSound(soundID); }

@end
