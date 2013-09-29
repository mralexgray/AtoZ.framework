// Copyright (C) 2004-2005 Nate Weaver (Wevah)
// (based on original work by Johan Sørensen)
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

#import "AtoZWebSnapper.h"
#import "AtoZWebSnapperWindowController.h"
#import "PreferencesController.h"
#import "MetalUI.h"
#import "AtoZ.h"

//#import "NSStringAdditions.h"


static AtoZWebSnapperWindowController *kController = nil;

@interface AtoZWebSnapperWindowController (Private)

- (NSMenu *)historyMenu;
- (NSMenu *)captureFromMenu;

@end

#pragma mark -

@implementation AtoZWebSnapperWindowController
@synthesize snapper;

- (id)initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {

		// Register notifications
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(webViewProgressStarted:) name:WebViewProgressStartedNotification object:snapper.webView];
		[center addObserver:self selector:@selector(webViewProgressEstimateChanged:) name:WebViewProgressEstimateChangedNotification object:snapper.webView];
		[center addObserver:self selector:@selector(webViewProgressFinished:) name:WebViewProgressFinishedNotification object:snapper.webView];
		
		[self setWindowFrameAutosaveName:@"MainWindow"];
		
		
		kController = self;
	}
	
	return self;
}

+ (void)initialize {
	NSDictionary *defaultDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithUnsignedInt:800],	kAZWebSnapperWebMinWidthKey,
		[NSNumber numberWithUnsignedInt:600],	kAZWebSnapperWebMinHeightKey,
		[NSNumber numberWithUnsignedInt:0],		kAZWebSnapperWebMaxWidthKey,
		[NSNumber numberWithUnsignedInt:0],		kAZWebSnapperWebMaxHeightKey,
		@"PNG",									kAZWebSnapperSaveFormatKey,
		[NSNumber numberWithFloat:0.8],			kAZWebSnapperJPEGQualityKey,
		@"%t (%y%m%d)",							kAZWebSnapperFilenameFormatKey,
		@"-thumb",								kAZWebSnapperThumbnailSuffixKey,
		[NSArray array],						kAZWebSnapperURLHistoryKey,
		[NSNumber numberWithUnsignedInt:10],	kAZWebSnapperMaxHistoryKey,
		[NSNumber numberWithBool:NO],			kAZWebSnapperUseGMTKey,
		[NSNumber numberWithFloat:0.25],		kAZWebSnapperThumbnailScaleKey,
		[NSNumber numberWithBool:YES],			kAZWebSnapperSaveImageKey,
		[NSNumber numberWithBool:NO],			kAZWebSnapperSaveThumbnailKey,
		[NSNumber numberWithFloat:0.0],			kAZWebSnapperDelayKey,
		@"PNG",									kAZWebSnapperThumbnailFormatKey,
		nil];
	[AZUSERDEFS registerDefaults:defaultDefaults];
}

+ (AtoZWebSnapperWindowController *)controller {
	return kController;
}

- (void)awakeFromNib {

	[urlField bind:@"stringValue" toObject:snapper withKeyPath:@"currentURL" options:nil];

	[snapper addObserver:self keyPath:@"webHistory" options:NSKeyValueChangeInsertion block:^(MAKVONotification *notification) {
		NSURL * i = snapper.webHistory.lastObject;
		NSLog(@"History has changed.  latest entry:%@", i);
		[self addURLToHistory:i];
	}];// forKeyPath:@"arr" options:0 context:@"myContext"];

	// Display the image
	[imageView bind:@"image" toObject:snapper withKeyPath:@"snap" options:nil];// setImage:dispImage];
	[self observeTarget:snapper keyPath:@"bitmap" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
		[previewField setStringValue:$(@"Preview (%lu %d %lu):", [snapper.bitmap pixelsWide], 0x00d7, [snapper.bitmap pixelsHigh])]; // 0x00d7 = multiplication sign
	}];

	[[self window] registerForDraggedTypes:@[NSURLPboardType, NSStringPboardType, NSFilenamesPboardType]];
	[imageView unregisterDraggedTypes];
	
	[urlField setStringValue:snapper.webHistory.count ? snapper.webHistory[0] : @"http://"];
	[openRecentMenuItem setSubmenu:[self historyMenu]];
	[urlField noteNumberOfItemsChanged];
	
	NSUI maxWidth = [AZUSERDEFS integerForKey:kAZWebSnapperWebMaxWidthKey];
	NSUI maxHeight = [AZUSERDEFS integerForKey:kAZWebSnapperWebMaxHeightKey];
	
	[minWidthField setIntegerValue:[AZUSERDEFS integerForKey:kAZWebSnapperWebMinWidthKey]];
	[minHeightField setIntegerValue:[AZUSERDEFS integerForKey:kAZWebSnapperWebMinHeightKey]];
	
	if (maxWidth)
		[maxWidthField setIntegerValue:maxWidth];
	if (maxHeight)
		[maxHeightField setIntegerValue:maxHeight];
	
	[delayField setFloatValue:[AZUSERDEFS floatForKey:kAZWebSnapperDelayKey]];

	self.window.excludedFromWindowsMenu = YES;
	
	captureFromMenuItem.submenu.delegate = (id)self;
	
#if 0
	[scriptMenuItem setTitle:@""];
	[scriptMenuItem setImage:[NSImage imageNamed:@"scriptMenu"]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popUpButtonWillPopUp:) name:NSPopUpButtonWillPopUpNotification object:takeURLFromPopUp];
	
	NSImage *image = [takeURLFromPopUp image];
	[takeURLFromPopUp setCell:[[[MetalPopUpButtonCell alloc] init] autorelease]];
	[takeURLFromPopUp setImage:image];
#endif
}

- (IBAction)fetch:(id)sender
{

	NSSize newSize = NSMakeSize([minWidthField floatValue], [minHeightField floatValue]);
	NSURL *url = [NSURL URLWithString:[urlField stringValue]];
	snapper.currentMax = NSMakeSize([maxWidthField floatValue], [maxHeightField floatValue]);
	snapper.currentDelay = [delayField floatValue];
	
	[AZUSERDEFS setInteger:[minWidthField intValue] forKey:kAZWebSnapperWebMinWidthKey];
	[AZUSERDEFS setInteger:[minHeightField intValue] forKey:kAZWebSnapperWebMinHeightKey];
	[AZUSERDEFS setInteger:[maxWidthField intValue] forKey:kAZWebSnapperWebMaxWidthKey];
	[AZUSERDEFS setInteger:[maxHeightField intValue] forKey:kAZWebSnapperWebMaxHeightKey];
	[AZUSERDEFS setFloat:snapper.currentDelay forKey:kAZWebSnapperDelayKey];

	[snapper.webWindow setContentSize:newSize];
	[scrollView.documentView setFrame:AZRectFromSize(newSize)];

	[snapper.webView setFrameSize:newSize];
	
	[self validateInputSchemeForControl:urlField];
		
	[[snapper.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)urlFieldEnter:(id)sender {
	[captureCancelButton performClick:sender];
}

- (void)cancel:(id)sender {
	[snapper.webView stopLoading:sender];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {	
	if ([error code] != -999) { // Don't show the sheet if the user cancelled.
		// what happens of something goes wrong while loading url (dns error etc)
		
		NSAlert *alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"LoadErrorTitle", nil), [urlField stringValue]]];
		[alert setInformativeText:[error localizedDescription]];
		[alert setAlertStyle:NSWarningAlertStyle];	
		
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
	}
}

- (void)webViewProgressStarted:(NSNotification *)notification {
	snapper.isLoading = YES;

	[NSObject cancelPreviousPerformRequestsWithTarget:self]; // stop pending captures

	[captureCancelButton setTitle:NSLocalizedString(@"Cancel", nil)];
	[captureCancelButton setAction:@selector(cancel:)];

	[pageLoadProgress setHidden:NO];
	[pageLoadProgress setDoubleValue:0.0];
}

- (void)webViewProgressEstimateChanged:(NSNotification *)notification {
	[pageLoadProgress setDoubleValue:[snapper.webView estimatedProgress]];
}

- (void)webViewProgressFinished:(NSNotification *)notification {
	snapper.isLoading = NO;

	[pageLoadProgress setHidden:YES];

	[captureCancelButton setTitle:[NSLocalizedString(@"Capture", nil) stringByAppendingString:@"!"]];
	[captureCancelButton setAction:@selector(fetch:)];
}
- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	// we don't really need to do anything here after the user has clicked 'ok' to the alert
	// other than releasing the object of course
}

- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSOKButton) {

		NSString *fileType = [[fileFormatPopUp selectedItem] title];
		float quality = [qualitySlider floatValue];
		NSURL *fileURL = [sheet URL];
		NSString *filename = [fileURL lastPathComponent];
		
		BOOL saveImage = [saveImageSwitch state] == NSOnState;
		float thumbnailScale = 0.0;
		NSString *thumbnailSuffix = nil;
		
		BOOL saveThumbnail = [saveThumbnailSwitch state] == NSOnState;
		
		if (saveThumbnail) {
			thumbnailScale = [thumbnailScaleField floatValue];
			thumbnailSuffix = [AZUSERDEFS objectForKey:kAZWebSnapperThumbnailSuffixKey];
		}
					
		if ([fileType isEqualToString:@"PNG"])
			[snapper saveAsPNG:filename fullSize:saveImage thumbnailScale:thumbnailScale thumbnailSuffix:thumbnailSuffix];
		else if ([fileType isEqualToString:@"TIFF"])
			[snapper saveAsTIFF:filename fullSize:saveImage thumbnailScale:thumbnailScale thumbnailSuffix:thumbnailSuffix];
		else if ([fileType isEqualToString:@"JPEG"])
			[snapper saveAsJPEG:filename usingCompressionFactor:quality fullSize:saveImage thumbnailScale:thumbnailScale thumbnailSuffix:thumbnailSuffix];
		else if ([fileType isEqualToString:@"PDF"]) {
			[snapper saveAsPDF:filename];
		} else
			NSLog(@"Bad file format: %@", fileType);
				
		[AZUSERDEFS setObject:fileType forKey:kAZWebSnapperSaveFormatKey];
		[AZUSERDEFS setFloat:quality forKey:kAZWebSnapperJPEGQualityKey];
		[AZUSERDEFS setFloat:thumbnailScale forKey:kAZWebSnapperThumbnailScaleKey];
		[AZUSERDEFS setBool:saveImage forKey:kAZWebSnapperSaveImageKey];
		[AZUSERDEFS setBool:saveThumbnail forKey:kAZWebSnapperSaveThumbnailKey];
		
		savePanel = nil;
	}
}

#pragma mark - Save

- (IBAction)saveDocumentAs:(id)sender {

	// figure out a suitable string for the filename
	NSString *host = [snapper.currentURL host];
	NSMutableString *suggestedFileName = [NSMutableString stringWithFormat:@"%@%@", host ? host : @"", [snapper.currentURL path]];
//	NSMutableString *suggestedFileName = [NSMutableString stringWithString:[snapper filenameWithFormat:[AZUSERDEFS objectForKey:kAZWebSnapperFilenameFormatKey]]];

	// Replace path delmiters
	[suggestedFileName replaceOccurrencesOfString:@"/" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [suggestedFileName length])];
	[suggestedFileName replaceOccurrencesOfString:@":" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [suggestedFileName length])];

	savePanel = [NSSavePanel savePanel];
	[savePanel setCanSelectHiddenExtension:YES];

	NSString *saveFormat = [AZUSERDEFS objectForKey:kAZWebSnapperSaveFormatKey];

	if ([fileFormatPopUp indexOfItemWithTitle:saveFormat] != -1)
		[fileFormatPopUp selectItemWithTitle:saveFormat];
	else
		[fileFormatPopUp selectItemWithTitle:@"PNG"];

	BOOL saveThumbnail = [AZUSERDEFS boolForKey:kAZWebSnapperSaveThumbnailKey];
	BOOL saveImage = [AZUSERDEFS boolForKey:kAZWebSnapperSaveImageKey];

	[saveThumbnailSwitch setState:saveThumbnail ? NSOnState : NSOffState];
	[thumbnailScaleField setEnabled:saveThumbnail];

	[saveImageSwitch setState:saveImage ? NSOnState : NSOffState];

	[qualitySlider setFloatValue:[[AZUSERDEFS objectForKey:kAZWebSnapperJPEGQualityKey] floatValue]];
	[self setFileFormat:fileFormatPopUp]; // Also sets the required file type.
	[savePanel setAccessoryView:accessoryView];
	[savePanel beginSheetForDirectory:nil file:suggestedFileName modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}


- (IBAction)setFileFormat:(id)sender {
	if (savePanel) {
		NSString *fileType = [[sender selectedItem] title];
	
		if ([fileType isEqualToString:@"PNG"]) {
			[savePanel setRequiredFileType:@"png"];
			[qualitySlider setEnabled:NO];
			[saveThumbnailSwitch setEnabled:YES];
			[saveImageSwitch setEnabled:YES];
		} else if ([fileType isEqualToString:@"TIFF"]) {
			[savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"tiff", @"tif", nil]];
			[qualitySlider setEnabled:NO];
			[saveThumbnailSwitch setEnabled:YES];
			[saveImageSwitch setEnabled:YES];
		} else if ([fileType isEqualToString:@"JPEG"]) {
			[savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"jpg", @"jpeg", @"jpe", nil]];
			[qualitySlider setEnabled:YES];
			[saveThumbnailSwitch setEnabled:YES];
			[saveImageSwitch setEnabled:YES];
		} else if ([fileType isEqualToString:@"PDF"]) {
			[savePanel setAllowedFileTypes:@[@"pdf"]];
			[qualitySlider setEnabled:NO];
			
			[saveThumbnailSwitch setEnabled:NO];
			[saveThumbnailSwitch setState:NSOffState];
			[saveImageSwitch setEnabled:NO];
			[saveImageSwitch setState:NSOnState];
			[thumbnailScaleField setEnabled:NO];
		} else
			NSLog(@"Bad file format!");
	}
}


- (IBAction)toggleSaveThumbnail:(id)sender
{
	[thumbnailScaleField setEnabled:((NSBUTT*)sender).state == NSOnState];
}

#pragma mark -

- (void)openDocument:(id)sender {
	[self showWindow:sender];
	[[self window] makeFirstResponder:urlField];
}

#pragma mark - URL History

- (void)addURLToHistory:(NSURL *)url
{
	NSLog(@"supposed to add: %@", url);
	unsigned max = [[AZUSERDEFS objectForKey:kAZWebSnapperMaxHistoryKey] unsignedIntValue];
	NSString *urlString = [url absoluteString];
	
	if ([snapper.webHistory containsObject:urlString])
		[snapper.webHistory removeObject:urlString];
	else if (snapper.webHistory.count > max)
		[snapper.webHistory removeObjectAtIndex:max - 1];
	
//	[snapper.webhistory insertObject:urlString atIndex:0];
	[urlField setNumberOfVisibleItems:MIN(10, snapper.webHistory.count)];
	[AZUSERDEFS setObject:snapper.webHistory forKey:kAZWebSnapperURLHistoryKey];
	[openRecentMenuItem setSubmenu:[self historyMenu]];
}

- (void)clearRecentDocuments:(id)sender {
	[snapper.webHistory removeAllObjects];
	[urlField noteNumberOfItemsChanged];
	[openRecentMenuItem setSubmenu:[self historyMenu]];
	[AZUSERDEFS setObject:snapper.webHistory forKey:kAZWebSnapperURLHistoryKey];
}

- (NSMenu *)historyMenu {
	NSMenu *menu = [[NSMenu alloc] initWithTitle:@"History"];
	
	if (snapper.webHistory.count) {NSEnumerator *histEnum = [snapper.webHistory objectEnumerator];
		NSString *urlString;
		
		while (urlString = [histEnum nextObject]) {
			[menu addItemWithTitle:urlString action:@selector(fetchWithMenuItem:) keyEquivalent:@""];
		}
		
		[menu addItem:[NSMenuItem separatorItem]];
	}
	
	[menu addItemWithTitle:NSLocalizedString(@"ClearMenu", nil) action:@selector(clearRecentDocuments:) keyEquivalent:@""];
	
	return menu;
}

- (void)fetchWithMenuItem:(id)sender {
	[self fetchUsingString:[sender title]];
}

#pragma mark -

- (void)warnOfMalformedPaparazziURL:(NSURL *)url {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:NSLocalizedString(@"MalformedURLTitle", nil)];
	[alert setInformativeText:[NSString stringWithFormat:NSLocalizedString(@"MalformedURLText", nil), [url absoluteString]]];
	[alert setAlertStyle:NSWarningAlertStyle];	
	
	[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];	
}

- (void)fetchUsingPaparazziURL:(NSURL *)url {
	if (url && [[url scheme] isEqualToString:@"paparazzi"]) {
		NSString *resource = [url resourceSpecifier];
		
		if ([resource hasPrefix:@"("]) { // has params
			NSUI lastparen = [resource rangeOfString:@")"].location;
			
			if (lastparen != NSNotFound) {
				unsigned width = 0;
				unsigned height = 0;
				int cropWidth = -1;
				int cropHeight = -1;
				
				NSString *params = [[[resource substringWithRange:NSMakeRange(1, lastparen - 1)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lowercaseString];
				
				NSArray *keyValuePairs = [params componentsSeparatedByString:@","];
				NSEnumerator *e = [keyValuePairs objectEnumerator];
				NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
				NSString *pair;
				
				while ((pair = [e.nextObject stringByTrimmingCharactersInSet:whitespace])) {
					NSArray *keyValue = [pair componentsSeparatedByString:@"="];
					
					NSString *key = [[keyValue objectAtIndex:0] stringByTrimmingCharactersInSet:whitespace];
					NSString *value = nil;
					
					if ([keyValue count] == 2)
						value = [[keyValue objectAtIndex:1] stringByTrimmingCharactersInSet:whitespace];
															
					if (key) {
						if (value) {
							if ([key isEqualToString:@"width"] || [key isEqualToString:@"minwidth"])
								width = [value intValue];
							else if ([key isEqualToString:@"height"] || [key isEqualToString:@"minheight"])
								height = [value intValue];
							else if ([key isEqualToString:@"cropwidth"] || [key isEqualToString:@"maxwidth"])
								cropWidth = [value intValue];
							else if ([key isEqualToString:@"cropheight"] || [key isEqualToString:@"maxheight"])
								cropHeight = [value intValue];
						}
						
						if ([key isEqualToString:@"nocrop"])
							cropWidth = cropHeight = 0;
					}
				}
				
				url = [NSURL URLWithString:[resource substringWithRange:NSMakeRange(lastparen + 1, [resource length] - lastparen - 1)]];
				
				if (url)
					[self fetchUsingString:[url absoluteString] minSize:NSMakeSize(width, height) cropSize:NSMakeSize(cropWidth, cropHeight)];
			} else {
				[self warnOfMalformedPaparazziURL:url];
			}
		} else { // no params
			url = [NSURL URLWithString:resource];
			
			if (url)
				[self fetchUsingString:[url absoluteString]];
		}
	} else // Pass http/https/file URLs on.
		[self fetchUsingString:[url absoluteString]];
}

- (void)fetchUsingString: (NSS*) string {
	if (string) {
		[NSApp activateIgnoringOtherApps:YES];
		[self showWindow:nil];
		[urlField setStringValue:string];
		[self fetch:nil];
	}
}

- (void)fetchUsingString: (NSS*) string minSize:(NSSize)minSize cropSize:(NSSize)cropSize {
	if (minSize.width > 0.0)
		[minWidthField setIntegerValue:minSize.width];	
	if (minSize.height > 0.0)
		[minHeightField setIntegerValue:minSize.height];
	if (cropSize.width > -0.5) {
		if (cropSize.width == 0.0)
			[maxWidthField setStringValue:@""];
		else
			[maxWidthField setIntegerValue:cropSize.width];
	}
	
	if (cropSize.height > -0.5) {
		if (cropSize.height == 0.0)
			[maxHeightField setStringValue:@""];
		else
			[maxHeightField setIntegerValue:cropSize.height];
	}
	
	[self fetchUsingString:string];
}

- (void)takeURLFromBrowser: (NSS*) name {
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"scpt" inDirectory:@"Take URL From"];
		
	if (path) {
		NSDictionary *err = nil;
		NSAppleScript *as = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
		if (err)
			NSLog(@"%@", err);		
		NSAppleEventDescriptor *aed = [as executeAndReturnError:&err];
		if (err)
			NSLog(@"%@", err);
		
		if (!err)
			[self fetchUsingString:[aed stringValue]];
	}
}

- (IBAction)takeURLFromMyBrowser:(id)sender {
	NSString *title = [sender title];
	
	if ([title rangeOfString:@"Camino"].location != NSNotFound)
		[self takeURLFromBrowser:@"Camino"];
	else if ([title rangeOfString:@"Safari"].location != NSNotFound)
		[self takeURLFromBrowser:@"Safari"];
}

#pragma mark -

// Drag and drop

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	NSPasteboard *pb = [sender draggingPasteboard];
	
	if ([[sender draggingSource] window] != [self window] && [pb availableTypeFromArray:[NSArray arrayWithObjects:NSURLPboardType, NSStringPboardType, NSFilenamesPboardType, nil]])
		return NSDragOperationCopy;

	return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSPasteboard *pb = [sender draggingPasteboard];
	NSString *type = [pb availableTypeFromArray:[NSArray arrayWithObjects:NSURLPboardType, NSStringPboardType, NSFilenamesPboardType, nil]];

	if (type) {
		NSURL *url = nil;
		
		if ([type isEqualToString:NSURLPboardType])
			url = [NSURL URLFromPasteboard:pb];
		else if ([type isEqualToString:NSStringPboardType])
			url = [NSURL URLWithString:[pb stringForType:NSStringPboardType]];
		else if ([type isEqualToString:NSFilenamesPboardType])
			url = [NSURL fileURLWithPath:[[pb propertyListForType:NSFilenamesPboardType] objectAtIndex:0]];
		
		if (url) {
			if ([[url scheme] isEqualToString:@"paparazzi"])
				[self fetchUsingPaparazziURL:url];
			else
				[self fetchUsingString:[url absoluteString]];
			
			return YES;
		}
	}
	
	return NO;
}

#pragma mark -

// NSApplication delegation

- (BOOL)application:(NSApplication *)app openFile: (NSS*) filename {
	NSURL *fileURL = [NSURL fileURLWithPath:filename];
	[urlField setStringValue:[fileURL absoluteString]];
	[self showWindow:nil];
	[self fetch:nil];
	return YES;
}

- (NSMenu *)captureFromMenu {
	static NSArray *kAppsIKnowHowToGetTheURLFrom;
	
	if (!kAppsIKnowHowToGetTheURLFrom)
		kAppsIKnowHowToGetTheURLFrom = [NSArray arrayWithObjects:@"Safari", @"Camino", nil];
	
	NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Dock Menu"];
	NSMenuItem *item;
	NSArray *apps = [[NSWorkspace sharedWorkspace] launchedApplications];
	NSEnumerator *appEnum = [apps objectEnumerator];
	NSDictionary *appDict;
	
	while (appDict = [appEnum nextObject]) {
		NSString *name = [appDict objectForKey:@"NSApplicationName"];
		if ([kAppsIKnowHowToGetTheURLFrom containsObject:name]) {
			item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"CaptureURLFrom", nil), name] action:@selector(takeURLFromMyBrowser:) keyEquivalent:@""];
			[menu addItem:item];
		}
	}
	
	return menu;	
}

- (NSMenu *)applicationDockMenu:(NSApplication *)app {
	return [self captureFromMenu];
}

- (BOOL)validateMenuItem:(NSMenuItem*)item {
	SEL action = [item action];
	
	if ((action == @selector(saveDocumentAs:)) && (!snapper.currentURL || !snapper.bitmap))
		return NO;
	else if (action == @selector(showWindow:)) {
		if ([[self window] isVisible])
			[item setState:NSOnState];
		else
			[item setState:NSOffState];
	} else if ((action == @selector(clearRecentDocuments:)) && ([snapper.webHistory count] == 0))
		return NO;
	
	return YES;
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication {
	if (![[self window] isVisible])
		[self showWindow:nil];
	
	return YES;
}

#pragma mark -

- (void)cancelOperation:(id)sender {
	if (snapper.isLoading)
		[self cancel:sender];
}

#if 0
- (IBAction)print:(id)sender {
	[imageView print:sender];
}
#endif

#pragma mark -

// urlField defaults

- (void)validateInputSchemeForControl:(NSControl *)control {
	[control setStringValue:[[control stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
	
	NSURL *url = [NSURL URLWithString:[control stringValue]];
	
	if (![[url scheme] length])
		[control setStringValue:[@"http://" stringByAppendingString:[control stringValue]]];	
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
	if (control == urlField)
		[self validateInputSchemeForControl:control];
	else if ((control == maxWidthField || control == maxHeightField) && [control intValue] < 1)
		[control setStringValue:@""];

	return YES;
}

- (IBAction)showPreferences:(id)sender {
	[[PreferencesController controller] showWindow:sender];
}

- (IBAction)sendFeedback:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:paparazzi@derailer.org?subject=Paparazzi!"]];
}

#if 0
- (void)popUpButtonWillPopUp:(NSNotification *)note {
	if ([note object] == takeURLFromPopUp) {
		NSMenu *menu = [self applicationDockMenu:NSApp];
		NSPopUpButton *popup = [note object];
		NSMenu *myMenu = [[note object] menu];
		[popup removeAllItems];
		
		unsigned count = [menu numberOfItems];
		
		unsigned i;
		NSMenuItem *item;
		
		[popup addItemWithTitle:@""];
		
		for (i = 0; i < count; ++i) {
			item = [[menu itemAtIndex:0] retain];
			[menu removeItemAtIndex:0];
			[myMenu addItem:item];
			[item release];
		}
	}
}
#endif

#pragma mark -

- (NSUI)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
	return snapper.webHistory.count;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index
{
	return snapper.webHistory[index];
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString: (NSS*) uncompletedString {	
	NSURL *url = [NSURL URLWithString:uncompletedString];
	if ([[url scheme] length] && (![[url resourceSpecifier] length] || [[url resourceSpecifier] isEqualToString:@"/"]))
		return uncompletedString;
		
	NSString *httpString;
	
	if (url && [[url scheme] length])
		httpString = uncompletedString;
	else
		httpString = [@"http://" stringByAppendingString:uncompletedString];
	
	NSEnumerator *e = [snapper.webHistory objectEnumerator];
	NSString *obj;
	
	while (obj = [e nextObject]) {
		if ([obj hasPrefix:httpString]) {
			if (url && [[url scheme] length])
				return obj;
			else
				return [obj substringFromIndex:7];
		}
	}
	
	return uncompletedString;
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
	if (menu == [captureFromMenuItem submenu]) {
		NSMenu *captureFromMenu = [self captureFromMenu];
		
		while ([menu numberOfItems])
			[menu removeItemAtIndex:0];
		
		NSEnumerator *e = [[captureFromMenu itemArray] objectEnumerator];
		NSMenuItem *item;
		
		while (item = [e nextObject])
			[menu addItem:[item copy]];
	}
}

@end
