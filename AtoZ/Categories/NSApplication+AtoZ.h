//
//  NSApplication+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenu (SBAdditions)

+ (instancetype) mennuWithItems:(NSA*)items;
- (void) setItemArray:(NSA*)items;

- (NSMenuItem *)selectedItem;
- (void) electItem:(NSMenuItem *)menuItem;
- (NSMenuItem *)selectItemWithRepresentedObject:(id)representedObject;
- (void) eselectItem;
- (NSMenuItem *)addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector tag:(NSInteger)tag;
- (NSMenuItem *)addItemWithTitle:(NSString *)aString representedObject:(id)representedObject target:(id)target action:(SEL)aSelector;
@end
@interface NSMenuItem (AtoZ)

- (id)initWithTitle:(NSString*)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString*)keyEquivalent representedObject:(id)representedObject;

@end

OBJC_EXPORT void SetDockIconImage(NSIMG *i);

extern NSString *const kShowDockIconUserDefaultsKey;

@interface NSApplication (AtoZ)

+ (id)		infoValueForKey:(NSS*)key;
- (BOOL)	showsDockIcon;
- (void)	setShowsDockIcon:(BOOL)flag;
@end

#import <Foundation/Foundation.h>

// All extensions methods in this file are thread-safe

#define kMultipartFileKey_MimeType @"mimeType" // NSString
#define kMultipartFileKey_FileName @"fileName"  // NSString
#define kMultipartFileKey_FileData @"fileData"  // NSData


@interface NSProcessInfo (Extensions)
- (BOOL) isDebuggerAttached;
@end


/*!
 @brief	Methods which Apple should have provided in NSWorkspace	*/
@interface NSWorkspace (AppleShoulda)

//- (NSString*) appName;
//- (NSString*) appDisplayName;
//- (NSString*) appVersion;
- (NSString*) appSupportSubdirectory;

- (void) registerDefaultsFromMainBundleFile:(NSString*)defaultsFilename;

+ (NSString*)appNameForBundleIdentifier:(NSString*)bundleIdentifier ;

+ (NSString*)bundleIdentifierForAppName:(NSString*)appName ;


@end

@interface NSWorkspace (SystemInfo)

+ (NSString*) systemVersion;

@end



//Attributes = 69632;
//        BundlePath = "/Applications/BetterTouchTool.app";
//        CFBundleExecutable = "/Applications/BetterTouchTool.app/Contents/MacOS/BetterTouchTool";
//        CFBundleIdentifier = "com.hegenberg.BetterTouchTool";
//        CFBundleName = BetterTouchTool;
//        CFBundleVersion = 0;
//        FileCreator = "????";
//        FileType = APPL;
//        Flavor = 3;
//        IsCheckedInAttr = 1;
//        LSBackgroundOnly = 0;
//        "LSCheckInTime*" = "2013-09-23 10:16:47 +0000";
//        LSLaunchTime = "2013-09-23 10:16:47 +0000";
//        LSSystemWillDisplayDeathNotification = 0;
//        LSUIElement = 1;
//        LSUIPresentationMode = 0;
//        PSN = 9406712;
//        ParentPSN = 9402615;
//        pid = 37298;					    },... ) 
		  
		  