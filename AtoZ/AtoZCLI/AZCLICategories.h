//
//  AZCLICategories.h
//  AtoZ
//
//  Created by Alex Gray on 4/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"


@interface AZCLI (Categories)
+ (void) setupBareBonesApplication;
+ (void) handleInteractionWithPrompt:(NSS*)string block:(void(^)(NSString *output))block;
//@property (RONLY) NSA 	*names, *colors;
//@property (RONLY) NSC 	*next;
//@property (STRNG) NSS	*name;
//
//- (id) objectAtIndexedSubscript:(NSUI)idx;
//
//+ (instancetype) instanceWithListNamed:(NSS*)listName;
//+ (instancetype) instanceWithColorList:(NSCL*)list;
//+ (instancetype) instanceWithNames:(NSA*)names;
//+ (instancetype) instanceWithColors:(NSA*)names;
//+ (NSS*) cliMenuFor:(NSA*)items starting:(NSUI)idx palette:(NSA*)p;


// send a simple program to clang using a GCD task
//- (void)provideStdin:(NSFileHandle *)stdinHandle;
// read the output from clang and dump to console
//- (void) getData:(NSNotification *)notifcation;
// invoke clang using an NSTask, reading output via notifications and providing input via an async GCD task
//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end

@interface AZCLIMenu : BaseModel
+ (NSIS*) indexesOfMenus;
@property (RONLY, NATOM) NSRNG		range;
@property (NATOM,STRNG)	 id			identifier;
@property (RONLY)		 	 NSS		*menu;
@property (NATOM,STRNG)  id 	palette;
@property (NATOM,  ASS)  NSI  startIdx;
+ (instancetype) cliMenuFor:(NSA*)items starting:(NSUI)idx palette:(id)p;
@end
