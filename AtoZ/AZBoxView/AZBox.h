//
//  AZBox.h
//  AtoZ
//
//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface AZBox : NSView
{
@protected
    NSImage *image;
	NSColor *_color;
    NSColor *selectionColor;
    BOOL selected;
	BOOL hovering;
    
@private
    NSInteger index;
    NSString *cellIdentifier;
    
    BOOL drawSelection;
}

/**
 * The identifier of the cell. Used for cell reusing.
 **/
@property (nonatomic, readonly) NSString *cellIdentifier;
/**
 * The image that should be drawn at the center of the cell, or nil if you don't want a image to be drawn.
 **/ 
@property (nonatomic) NSImage *image;

/**
 * The color of the selection ring.
 **/
@property (nonatomic) NSColor *selectionColor;
/**
 * YES if the cell should draw an selection ring. You can set this to NO if you don't want to show a selection ring or if you provide your own. 
 * The default value is YES.
 **/
@property (nonatomic, assign) BOOL drawSelection;
/**
 * YES if the cell is selected, otherwise NO.
 **/
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/**
 * YES if the mouse is hovering over cell, otherwise NO.
 **/
@property (nonatomic, assign, getter=isHovering) BOOL hovering;

@property (nonatomic) NSColor *color;
@property (nonatomic) NSBezierPath *path;
@property (nonatomic) NSGradient *gradient;
@property (nonatomic) id representedObject;
@property (assign) CGFloat radius;
@property (assign) NSCompositingOperation composite;

/**


 * Invoked when the cell is dequeued from a collection view. This will reset all settings to default.
 **/
- (void)prepareForReuse;

/**
 * The designated initializer of the cell. Please don't use any other intializer!
 **/
- (id)initWithReuseIdentifier:(NSString *)identifer;

//@end@property (nonatomic, retain) NSColor *pattern;
//@property (nonatomic, retain) NSImage *image;
//@property (nonatomic, retain) NSColor *color;
//@property (assign) NSUInteger tag;
//@property (assign) BOOL selected;
//@property (assign) BOOL hovering;
//@property (assign) NSCompositingOperation composite;
//
//@property (nonatomic, retain) id representedObject;
//@property (nonatomic, retain) id string;
//@property (assign) CGFloat radius;
//@property (nonatomic, retain) NSString *cellIdentifier;
//
//- (id)initWithReuseIdentifier:(NSString *)identifier;
//- (id)initWithObject:(id)object;

@end
