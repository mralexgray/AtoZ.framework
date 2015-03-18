//
//  NSApplication+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

@interface NSMenu (Dark)
@property (nonatomic) BOOL dark;
@end

#define MENUBLK void(^)(NSMenuItem * menuItem)
#define PERFORMSELNIL(A,B) [A performSelector:@selector(B) withObject:nil]

@interface NSMenu (AtoZ)

+ _Kind_ menuWithTitlesAndActions:_Text_ firstTitle,...;

@end

@interface	NSMenuItem   (AtoZ)

- initWithTitle:_Text_ tit target:t action:_Meth_ s keyEquivalent:_Text_ k representedObject:x;

+ itemWithTitle:_Text_ title keyEquivalent:_Text_ key block:(MENUBLK)block;

@prop_NC MItemBlk actionBlock;

+ _Kind_ menuWithTitle:_Text_ tit key:_Text_ k action:blck;

@end

@interface NSControl (ActionBlock)
@prop_NC ObjBlk actionBlock;
@end


@interface NSMenu (SBAdditions)

+ (INST) menuWithItems:(NSA*)items;
- (void) setItemArray:(NSA*)items;

- (NSMI*) selectedItem;
-  (void) selectItem:(NSMI*)menuItem;
- (NSMI*) selectItemWithRepresentedObject: representedObject;
- (void) deselectItems;
- (NSMenuItem *)addItemWithTitle:(NSString *)aString target: target action:(SEL)aSelector tag:(NSInteger)tag;
- (NSMenuItem *)addItemWithTitle:(NSString *)aString representedObject: representedObject target: target action:(SEL)aSelector;
@end

OBJC_EXPORT void SetDockIconImage(NSIMG *i);

extern NSString *const kShowDockIconUserDefaultsKey;

@interface NSApplication (AtoZ)

@property (nonatomic) BOOL launchAtLogin;

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
- _IsIt_ isDebuggerAttached;
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
		  
		  
