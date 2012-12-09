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

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@class AtoZWebSnapper;
@interface AtoZWebSnapperWindowController : NSWindowController
{
    IBOutlet NSComboBox				*urlField;

	IBOutlet NSScrollView			*scrollView;
	IBOutlet NSImageView			*imageView;
	IBOutlet NSTextField			*minWidthField;
	IBOutlet NSTextField			*minHeightField;
	IBOutlet NSTextField			*maxWidthField;
	IBOutlet NSTextField			*maxHeightField;
	IBOutlet NSTextField			*delayField;
	
	IBOutlet NSProgressIndicator	*pageLoadProgress;
	IBOutlet NSButton				*saveButton;
	IBOutlet NSButton				*captureCancelButton;
	IBOutlet NSTextField			*previewField;
	
	
	IBOutlet NSMenuItem		*openRecentMenuItem;
	IBOutlet NSMenuItem		*captureFromMenuItem;
	
	NSSavePanel				*savePanel;
	IBOutlet NSView			*accessoryView;
	IBOutlet NSPopUpButton	*fileFormatPopUp;
	IBOutlet NSSlider		*qualitySlider;
	IBOutlet NSButton		*saveImageSwitch;
	IBOutlet NSButton		*saveThumbnailSwitch;
	IBOutlet NSTextField	*thumbnailScaleField;
	
	//IBOutlet NSMenuItem		*scriptMenuItem;
//	NSMutableArray			*history;
}

@property (assign) IBOutlet AtoZWebSnapper *snapper;

+ (AtoZWebSnapperWindowController *)controller;

- (IBAction)fetch:(id)sender;
- (IBAction)urlFieldEnter:(id)sender; // Workaround for the button not being pressed on return key push just after launch.
- (void)cancel:(id)sender;

- (void)fetchUsingPaparazziURL:(NSURL *)url;
- (void)fetchUsingString: (NSS*) string;
- (IBAction)takeURLFromMyBrowser:(id)sender;

- (IBAction)saveDocumentAs:(id)sender;
- (IBAction)setFileFormat:(id)sender;
- (IBAction)toggleSaveThumbnail:(id)sender;
//- (IBAction)toggleFullsize:(id)sender;

- (IBAction)showPreferences:(id)sender;
- (IBAction)sendFeedback:(id)sender;

@end
