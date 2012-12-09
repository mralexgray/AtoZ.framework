//
//  PreferencesController.m
//  Paparazzi!
//
//  Created by Wevah on 2005.08.22.
//  Copyright 2005 Derailer. All rights reserved.
//

#import "AtoZWebSnapper.h"
#import "PreferencesController.h"


static PreferencesController *kController = nil;

@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window {
	if (!kController && (self = [super initWithWindow:window])) {
		[self setWindowFrameAutosaveName:@"Preferences"];
		kController = self;
	}
	
	return kController;
}

+ (PreferencesController *)controller {
	if (!kController)
		[[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
	
	return kController;
}

- (void)awakeFromNib {
	NSUserDefaults *defaults = AZUSERDEFS;
	
	[filenameFormatField setStringValue:[defaults objectForKey:kAZWebSnapperFilenameFormatKey]];
	[maxHistoryField setIntValue:[defaults integerForKey:kAZWebSnapperMaxHistoryKey]];
	[GMTSwitch setState:[defaults boolForKey:kAZWebSnapperUseGMTKey] ? NSOnState : NSOffState];
	[thumbnailSuffixField setStringValue:[defaults objectForKey:kAZWebSnapperThumbnailSuffixKey]];
}

#pragma mark -

- (IBAction)setFilenameFormat:(id)sender {
	[AZUSERDEFS setObject:[sender stringValue] forKey:kAZWebSnapperFilenameFormatKey];
}

- (IBAction)setMaxHistory:(id)sender {
	if (![sender intValue])
		[sender setIntValue:0];
	
	[AZUSERDEFS setInteger:[sender intValue] forKey:kAZWebSnapperMaxHistoryKey];
}

- (IBAction)setUseGMT:(id)sender {
	[AZUSERDEFS setBool:((NSBUTT*)sender).state == NSOnState forKey:kAZWebSnapperUseGMTKey];
}

- (IBAction)setThumbnailSuffix:(id)sender {
	[AZUSERDEFS setObject:[sender stringValue] forKey:kAZWebSnapperThumbnailSuffixKey];
}

- (void)controlTextDidChange:(NSNotification *)note {
	NSControl *control = [note object];
	NSFormatter *formatter = [control formatter];
	NSText *editor = [[note userInfo] objectForKey:@"NSFieldEditor"];
	
	if (!formatter || [formatter getObjectValue:nil forString:[editor string] errorDescription:nil]) {
		// Don't try to set the default if the formatter says NO, so the field doesn't end editing and clear itself.
		if (control == filenameFormatField)
			[self setFilenameFormat:control];
		if (control == thumbnailSuffixField)
			[self setThumbnailSuffix:control];
		else if (control == maxHistoryField)
			[self setMaxHistory:control];
		else
			NSLog(@"Prefs error.");
	}
}

@end
