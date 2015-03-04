//
//  main.m
//  AtoZTouchTester
//
//  Created by Alex Gray on 3/2/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.

//#import <InstaBanner.h>

@import AtoZTouch;

int main (int argc, const char * argv[]){  @autoreleasepool {

    AtoZTouchWelcome();
//    [InstaBanner showBannerWithBundleIdentifier:@"com.apple.MobileSafari" title:@"well hello" message:@"huge vageen"];
  }
	return 0;
}

//  AudioServicesPlaySystemSound(1005);
//  
//  // ivar
//  SystemSoundID mBeep;
//  dispatch_queue_t pq = dispatch_queue_create("PQ", NULL);	// create our main processing queue
//
//  // Create the sound ID
////  NSString* path = // [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"aiff"];
//
//  NSURL* url = [NSURL fileURLWithPath:@"/System/Library/CoreServices/AssistiveTouch.app/Drill.aiff"];
//  AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mBeep);
//
//  dispatch_sync(pq, ^{
//
//    // Play the sound
//    AudioServicesPlaySystemSound(mBeep);
//
//  });
//
//  // Dispose of the sound
//  AudioServicesDisposeSystemSoundID(mBeep);


