//
//  PreferencesController.h
//  Paparazzi!
//
//  Created by Wevah on 2005.08.22.
//  Copyright 2005 Derailer. All rights reserved.
//
// Copyright (C) 2004-2005 Nate Weaver (Wevah)
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


@interface PreferencesController : NSWindowController {
	IBOutlet NSTextField	*filenameFormatField;
	IBOutlet NSTextField	*maxHistoryField;
	IBOutlet NSButton		*GMTSwitch;
	IBOutlet NSTextField	*thumbnailSuffixField;
}

+ (PreferencesController *)controller;

- (IBAction)setFilenameFormat:(id)sender;
- (IBAction)setMaxHistory:(id)sender;
- (IBAction)setUseGMT:(id)sender;
- (IBAction)setThumbnailSuffix:(id)sender;

@end
