//
//  NSWorkspace+SystemInfo.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSWorkspace+SystemInfo.h"
@implementation NSWorkspace (SystemInfo)

+ (NSString*) systemVersion {
    SInt32 versionMajor, versionMinor, versionBugFix;
	
	OSErr maj = Gestalt(gestaltSystemVersionMajor, &versionMajor);
	OSErr min = Gestalt(gestaltSystemVersionMinor, &versionMinor);
	OSErr bug = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
	
	if (maj != noErr || min != noErr || bug != noErr)
		return nil;
	
    return $(@"%d.%d.%d", versionMajor, versionMinor, versionBugFix);
}

@end

@implementation NSWorkspace (JAAdditions)

- (void)openURLInBackground:(NSURL *)url {
	[self openURLsInBackground:[NSArray arrayWithObject:url]];
}

- (void)openURLsInBackground:(NSArray *)urls {
	LSLaunchURLSpec urlSpec;

	urlSpec.appURL = nil;
	urlSpec.itemURLs = (CFArrayRef) urls;
	urlSpec.passThruParams = nil;

	urlSpec.launchFlags = kLSLaunchDontSwitch;
	urlSpec.asyncRefCon = nil;

	LSOpenFromURLSpec(&urlSpec, nil);
}

- (void)openURLs:(NSArray *)urls {
	for(NSURL *url in urls) {
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}

- (NSString *)applicationSupportDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	return (paths.count > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
}

- (NSString *)preferencesDirectory {
    FSRef desktopFolderRef;

    FSFindFolder(kUserDomain, kPreferencesFolderType, kDontCreateFolder, &desktopFolderRef);
    CFURLRef url = CFURLCreateFromFSRef(kCFAllocatorSystemDefault, &desktopFolderRef);
    CFMakeCollectable(url);

	return (NSString *) CFMakeCollectable(CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle));
}

@end
