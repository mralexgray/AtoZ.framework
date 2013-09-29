//
//  NSApplication+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSApplication+AtoZ.h"
#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <sys/xattr.h>
#else
#import <CoreServices/CoreServices.h>
#endif
#import <libkern/OSAtomic.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <dirent.h>
#import <sys/stat.h>

#import "AtoZ.h"


@implementation NSMenu (SBAdditions)

- (NSMenuItem *)selectedItem
{
	NSMenuItem *menuItem = nil;
	for (NSMenuItem *item in [self itemArray])
	{
		if ([item state] == NSOnState)
		{
			menuItem = item;
			break;
		}
	}
	return menuItem;
}

- (void)selectItem:(NSMenuItem *)menuItem
{
	for (NSMenuItem *item in [self itemArray])
	{
		[item setState:(item == menuItem ? NSOnState : NSOffState)];
	}
}

- (NSMenuItem *)selectItemWithRepresentedObject:(id)representedObject
{
	NSMenuItem *selectedItem = nil;
	for (NSMenuItem *item in [self itemArray])
	{
		id repObject = [item representedObject];
		BOOL equal = (!repObject && !representedObject) || [repObject isEqualTo:representedObject];
		[item setState:(equal ? (selectedItem ? NSOffState : NSOnState) : NSOffState)];
		if (equal)
		{
			if (!selectedItem)
				selectedItem = item;
		}
	}
	return selectedItem;
}

- (void)deselectItem
{
	for (NSMenuItem *item in [self itemArray])
	{
		[item setState:NSOffState];
	}
}

- (NSMenuItem *)addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector tag:(NSInteger)tag
{
	NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
	[item setTitle:aString];
	[item setTarget:target];
	[item setAction:aSelector];
	[item setTag:tag];
	[self addItem:item];
	return item;
}

- (NSMenuItem *)addItemWithTitle:(NSString *)aString representedObject:(id)representedObject target:(id)target action:(SEL)aSelector
{
	NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
	[item setTitle:aString];
	[item setTarget:target];
	[item setAction:aSelector];
	[item setRepresentedObject:representedObject];
	[self addItem:item];
	return item;
}

@end
@implementation NSMenuItem (AtoZ)

- (id)initWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSS*)keyEquivalent representedObject:(id)representedObject;

{
	if (self != super.init) return self;
	[self setTitle:aString];
	[self setTarget:target];
	[self setAction:aSelector];
	[self setRepresentedObject:representedObject];
	[self setKeyEquivalent:keyEquivalent];

	return self;
}

@end

NSString *const kShowDockIconUserDefaultsKey = @"ShowDockIcon";
@implementation NSApplication (AtoZ)

+ (id)infoValueForKey:(NSS*)key {
	if ([[NSBundle mainBundle] localizedInfoDictionary][key]) {
		return [[NSBundle mainBundle] localizedInfoDictionary][key];
	}

	return [[NSBundle mainBundle] infoDictionary][key];
}

- (BOOL)showsDockIcon {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kShowDockIconUserDefaultsKey];
}

	/** this should be called from the application delegate's applicationDidFinishLaunching method or from some controller object's awakeFromNib method neat dockless hack using Carbon from <a href="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it" title="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it">http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-...</a> */
	
- (void)setShowsDockIcon:(BOOL)flag {

	if (flag) {
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		// display dock icon
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		// enable menu bar
		SetSystemUIMode(kUIModeNormal, 0);

		// switch to Dock.app
		if ([[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil] == NO) {
			NSLog(@"Could not launch application with identifier 'com.apple.dock'.");
		}

		// switch back
		[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	}
}
@end



@implementation NSProcessInfo (Extensions)

// From http://developer.apple.com/mac/library/qa/qa2004/qa1361.html
- (BOOL) isDebuggerAttached {
	struct kinfo_proc info;
	info.kp_proc.p_flag = 0;

	int mib[4];
	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();
	size_t size = sizeof(info);
	int result = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);

	return !result && (info.kp_proc.p_flag & P_TRACED);  // We're being debugged if the P_TRACED flag is set
}

@end


@implementation NSWorkspace (AppleShoulda)


//- (NSString*) appName {
//	if (SDInfoPlistValueForKey(@"CFBundleName"))
//		return SDInfoPlistValueForKey(@"CFBundleName");
//	else
//		return [[[NSFileManager defaultManager] displayNameAtPath:[[NSBundle mainBundle] bundlePath]] stringByDeletingPathExtension];
//}

//- (NSString*) appDisplayName {
//	if (SDInfoPlistValueForKey(@"CFBundleDisplayName"))
//		return SDInfoPlistValueForKey(@"CFBundleDisplayName");
//	else
//		return [NSApp appName];
//}
//
//- (NSString*) appVersion {
//	return SDInfoPlistValueForKey(@"CFBundleVersion");
//}

- (NSString*) appSupportSubdirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *appSupportFolder = [paths firstObject];
	NSString *appSupportSubdirectory = [appSupportFolder stringByAppendingPathComponent:APP_NAME];//[NSApp appDisplayName]];

	NSError *error = nil;
	[[NSFileManager defaultManager] createDirectoryAtPath:appSupportSubdirectory withIntermediateDirectories:YES attributes:nil error:&error];
	if (error) {
		[NSException raise:@"SDCannotCreateDir"
					format:@"Cannot create folder [%@]", appSupportSubdirectory];
		return nil;
	}

	return appSupportSubdirectory;
}

- (void) registerDefaultsFromMainBundleFile:(NSString*)defaultsFilename {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:[defaultsFilename stringByDeletingPathExtension]
														  ofType:[defaultsFilename pathExtension]];

	NSDictionary *initialValues = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults:initialValues];
}


+ (NSString*)appNameForBundleIdentifier:(NSString*)bundleIdentifier {
	NSWorkspace* workspace = [self sharedWorkspace] ;
	NSString* path = [workspace absolutePathForAppBundleWithIdentifier:bundleIdentifier] ;
	NSBundle* bundle = [NSBundle bundleWithPath:path] ;
	NSString* appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"] ;

	// Added in BookMacster version 1.3.22
	if (bundle) {
		if ([appName length] == 0) {
			NSLog(@"Warning 562-0981.  No CFBundleName in %@", bundleIdentifier) ;
			appName = [bundle objectForInfoDictionaryKey:@"CFBundleExecutable"] ;
			if ([appName length] == 0) {
				NSLog(@"Warning 562-0982.  No CFBundleExecutable in %@", bundleIdentifier) ;
				appName = [bundleIdentifier lastPathComponent] ;
			}
		}
	}

	return appName ;
}

+ (NSString*)bundleIdentifierForAppName:(NSString*)appName  {
	NSWorkspace* workspace = [self sharedWorkspace] ;
	NSString* path = [workspace fullPathForApplication:appName] ;
	NSBundle* bundle = [NSBundle bundleWithPath:path] ;
	NSString* bundleIdentifier = [bundle bundleIdentifier] ;
	return bundleIdentifier ;
}

@end


@implementation NSWorkspace (SystemInfo)

+ (NSString*) systemVersion {
	SInt32 versionMajor, versionMinor, versionBugFix;

	OSErr maj = Gestalt(gestaltSystemVersionMajor, &versionMajor);
	OSErr min = Gestalt(gestaltSystemVersionMinor, &versionMinor);
	OSErr bug = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);

	if (maj != noErr || min != noErr || bug != noErr)
		return nil;

	return NSSTRINGF(@"%d.%d.%d", versionMajor, versionMinor, versionBugFix);
}

@end
