//
//  CustomView.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

@class  AZStatusItemView;
@protocol AZStatusItemDelegate <NSObject>
@optional
/*** Invoked when the cell at the given index was selected.  **/
- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active;
@end

//@class AZStatusAppController;
@interface AZStatusItemView : NSView {
//	AZStatusAppController *controller;
  id <AZStatusItemDelegate> __unsafe_unretained delegate;
}

@property (assign)  BOOL clicked;
@property (nonatomic, retain) AZFile *file;

/*** The delegate of the collection view.  **/
@property (nonatomic, unsafe_unretained) IBOutlet id <AZStatusItemDelegate> delegate;

//@property (nonatomic, retain) NSProgressIndicator *indicator;

//- (id)initWithFrame:(NSRect)frame controller:(AZStatusAppController *)ctrlr;
@property (retain) NSRunningApplication *currentApp;

@end
