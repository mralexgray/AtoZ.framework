//
//  AppDelegate.h
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <AtoZ/AtoZ.h>
#import "SDToolkit.h"
#import "SDCommonAppDelegate.h"

@interface EncyclopediaDelegate : SDCommonAppDelegate  <NSApplicationDelegate> {
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	
}
@property (retain, nonatomic) NSMutableArray *noteControllers;

- (IBAction) addNote:(id)sender;
- (IBAction) removeAllNotes:(id)sender;

@end
