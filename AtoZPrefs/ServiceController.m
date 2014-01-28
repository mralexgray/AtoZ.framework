//
//  ServiceController.m
//  AtoZPrefs
//
//  Created by Josh Butts on 3/28/13.
//  Copyright (c) 2013 Josh Butts. All rights reserved.
//

#import "ServiceController.h"
#import "Service.h"


@implementation ServiceController	@synthesize service, launchAgentPath;

-(id) initWithService:(Service *)theService {
    self = [super init];
    service = theService;
    launchAgentPath = [NSString stringWithFormat:@"%@%@%@", NSHomeDirectory(), @"/Library/LaunchAgents/", self.service.plistFilename];
    return self;
}

-(BOOL) running {

    NSTask *command = [[NSTask alloc] init];
    NSString *bashCommand = [NSString stringWithFormat:@"%@%@", @"/bin/launchctl list | grep ", self.service.identifier];
    NSArray *args = [NSArray arrayWithObjects:@"-c", bashCommand, nil];
    NSPipe *stdOut = [NSPipe pipe];
    
    [command setLaunchPath:@"/bin/bash"];
    [command setArguments:args];
    [command setStandardOutput:stdOut];
    [command launch];
    [command waitUntilExit];
    
    NSFileHandle *read = [stdOut fileHandleForReading];
    NSData *readData = [read readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    if ([output length] > 0) {
        return YES;
    }
    return NO;
    
}

-(BOOL) startAtLogin {   return NO; } //[ fileExistsAtPath:self.launchAgentPath]


-(void) setStartAtLogin:(BOOL) shouldStartAtLogin {
//    [AZFILEMANAGER removeItemAtPath:self.launchAgentPath error:nil];
//    if (shouldStartAtLogin)   [self.fm createSymbolicLinkAtPath:self.launchAgentPath withDestinationPath:self.service.plist error:nil];

}

//-(void) stop {
//    NSTask *command = [[NSTask alloc] init];
//    NSArray *args = [NSArray arrayWithObjects:@"unload", self.service.plist, nil];
//    
//    [command setLaunchPath:@"/bin/launchctl"];
//    [command setArguments:args];
//    [command launch];
//    [command waitUntilExit];
//
//}
//
//-(void) start {
//    NSTask *command = [[NSTask alloc] init];
//    NSArray *args = [NSArray arrayWithObjects:@"load", self.service.plist, nil];
//    
//    [command setLaunchPath:@"/bin/launchctl"];
//    [command setArguments:args];
//    [command launch];
//    [command waitUntilExit];
///}
+ (NSMutableArray *) enumerateWithBundle:(NSBundle *)bundle {

    [self createServicesDirectory];
    NSMutableArray *services 		= NSMutableArray.new;
    NSFileManager *fileManager 	= NSFileManager.new;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:@"/usr/local/etc/AtoZPrefs" error:nil];
    for (NSString *file in files) {
		NSString *extension = [file substringFromIndex:[file length] - 5];
      if (![@"plist" isEqualToString:extension]) return nil;
		NSString *fullFilePath 					= [NSString stringWithFormat:@"%@%@", @"/usr/local/etc/AtoZPrefs/", file];
		NSDictionary *plistData 				= [NSDictionary.alloc initWithContentsOfFile: fullFilePath];
		NSMutableDictionary *AtoZPrefsData 	= [plistData objectForKey:@"AtoZPrefs"];
		if (AtoZPrefsData == nil) continue;
		[AtoZPrefsData setObject: file forKey:@"plist"];
		BOOL imageIsLoadable = [fileManager fileExistsAtPath:[AtoZPrefsData objectForKey:@"image"]];
		NSImage *image;
		if (imageIsLoadable)
			image = [NSImage.alloc initWithContentsOfFile:[AtoZPrefsData objectForKey:@"image"]];
		else {
			 NSString *resourcePath = [bundle resourcePath];
			 NSString *iconPath = [NSString stringWithFormat:@"%@%@%@", resourcePath, @"/", [AtoZPrefsData objectForKey:@"image"]];
			 image = [[NSImage alloc] initWithContentsOfFile: iconPath];
		}
		if (image == nil)	 continue;
		else	[AtoZPrefsData setObject:image forKey:@"image"];
		Service *service = [Service.alloc initWithOptions:AtoZPrefsData];
		[services addObject:service];
	}
   return services;
}

+ (void) createServicesDirectory {

	NSError *e;
	[NSFileManager.new createDirectoryAtURL:[NSURL URLWithString:@"/usr/local/etc/AtoZPrefs"] withIntermediateDirectories:YES attributes:nil error:&e];
	if (e) { NSBeep(); NSLog(@"%@",e); }

}

@end
