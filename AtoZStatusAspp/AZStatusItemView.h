//
//  CustomView.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

@class AZStatusAppController;
@interface AZStatusItemView : NSView {
	AZStatusAppController *controller;
}

@property (assign)  BOOL clicked;
//@property (nonatomic, retain) NSProgressIndicator *indicator;

- (id)initWithFrame:(NSRect)frame controller:(AZStatusAppController *)ctrlr;

@end
