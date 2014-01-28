//
//  SDPreferencesController.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SDNoteAppearanceDidChangeNotification @"SDNoteAppearanceDidChangeNotification"

#import "SDPreferencesController.h"

@interface SDGeneralPrefPane : NSViewController <SDPreferencePane> {

}

- (IBAction) changeAppearance:(id)sender;

@end
