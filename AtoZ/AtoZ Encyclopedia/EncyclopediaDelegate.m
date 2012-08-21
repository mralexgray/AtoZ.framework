//
//  AppDelegate.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "EncyclopediaDelegate.h"

#import "SDNoteWindowController.h"
#import "SDGeneralPrefPane.h"

@interface EncyclopediaDelegate (Private)

- (void) createNoteWithDictionary:(NSDictionary*)dictionary;
- (void) loadNotes;
- (void) saveNotes;

@end

@implementation EncyclopediaDelegate
@synthesize noteControllers;

- (id) init {
	if (self = [super init]) {
		self.noteControllers = [NSMutableArray array];// retain];
	}
	return self;
}

- (void) awakeFromNib {
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	[statusItem setImage:[NSImage systemImages].randomElement];
	// [NSImage imageNamed:@"atoz"]];//statusimage"]];
	[statusItem setAlternateImage:[NSImage systemImages].randomElement];
//[NSImage imageNamed:@"statusimage_pressed"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
}

// app delegate methods

- (void) applicationDidFinishLaunching:(NSNotification*)notification {
//	[self loadNotes];
}

- (void) applicationDidResignActive:(NSNotification *)notification {
//	[[NSApplication sharedApplication]hide:self];
}
- (void)applicationWillTerminate:(NSNotification *)notification {
	[self saveNotes];
}



// persistance

- (void) loadNotes {
	NSArray *notes = [SDDefaults arrayForKey:@"notes"];

	if ([notes count] == 0) {
		[self showInstructionsWindow:self];
		[self setOpensAtLogin:YES];
		return;
	}

//	NSArray *start = @[ @{ 	@"frame": NSStringFromRect(<#NSRect aRect#>)

	for (NSDictionary *dict in notes){
		[self createNoteWithDictionary:dict];
//		NSLog(@"dict %@", dict.description);
	}
	
//	[self createNoteWithDictionary:@{@"title":@"welcome to your app", @"frame": NSStringFromRect( NSMakeRect(1347, 669,404, 77))}];
}


- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];
	
	for (SDNoteWindowController *controller in self.noteControllers)
		[array addObject:[controller dictionaryRepresentation]];
	
	[SDDefaults setObject:array forKey:@"notes"];
}

// validate menu items

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(addNote:))
		return YES;
	if ([menuItem action] == @selector(removeAllNotes:))
		return ([self.noteControllers count] > 0);
	else
		return [super validateMenuItem:menuItem];
}

// adding and creating notes

- (void) createNoteWithDictionary:(NSDictionary*)dictionary {
	SDNoteWindowController *controller = [[SDNoteWindowController alloc] initWithDictionary:dictionary];// autorelease];
	[self.noteControllers addObject:controller];
}

- (void) removeNoteFromCollection:(SDNoteWindowController*)controller {
	[self.noteControllers removeObject:controller];
}

- (IBAction) addNote:(id)sender {
	[self createNoteWithDictionary:nil];
}
- (IBAction) loadEm:(id)sender {
	[self loadNotes];
}

- (IBAction) removeAllNotes:(id)sender {
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	
	[alert setMessageText:@"Remove all desktop labels?"];
	[alert setInformativeText:@"This operation cannot be undone. Seriously."];
	
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	
	if ([alert runModal] == NSAlertFirstButtonReturn)
		[self.noteControllers removeAllObjects];
}


// specifics

- (void) appRegisteredSuccessfully {
	[self loadNotes];
}

- (NSArray*) instructionImageNames {
	return @[ @"1.pdf", @"2.pdf", @"3.pdf" ];
}

- (BOOL) showsPreferencesToolbar {
	return YES;
}

- (NSArray*) preferencePaneControllerClasses {
	return @[[SDGeneralPrefPane class]];
}

@end
