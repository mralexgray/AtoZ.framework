
//  AZSimpleView.h
//  AtoZ

//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.

#import "AtoZUmbrella.h"

@interface AZSimpleView : NSView
@property (assign) BOOL clear, glossy, gradient, checkerboard;
@property (nonatomic, strong) NSColor *backgroundColor;

+ (instancetype) withFrame:(NSR)f      color:(NSC*)c;
-         (void) setFrameSizePinnedToTopLeft:(NSSZ)size;

@end

@interface AZSimpleGridView : NSView
@property (NATOM, ASS) NSSize dimensions;
@property (nonatomic, retain)  CALayer *grid;
@property (NATOM, ASS) NSUInteger rows, columns;

@end


@interface NSTableRowView (AtoZ)
@property (readonly) id object;
@property (readonly) NSUI index;
@property (readonly) NSOV *enclosingView;
@end

@interface AZOutlineView : NSOutlineView
@property void(^rowBlock)(NSTableRowView*);
@end

// This should get made in -(NSV*)tableView:(NSTV*)t rowViewForRow:(NSI)r;
// ColorTableRowView *rowView = [t makeViewWithIdentifier:NSTableViewRowViewKey owner:self];

@interface ColorTableRowView : NSTableRowView
@property (readonly) id xObjectValue;
@end
