//
//  SNRHUDButtonCell.h
//  SNRHUDKit
//
//  Created by Indragie Karunaratne on 12-01-23.
//  Copyright (c) 2012 indragie.com. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "AtoZ.h"

// TODO: Drawing images
// TODO: Checkbox & radio buttons

@class SNRHUDButtonCell;
@protocol SNRHUDViewDelegate <NSObject>
@optional
-  (BOOL) cellShouldDrawCheckBoxesShaded:(SNRHUDButtonCell*)cell ;
@end

@interface SNRHUDButtonCell : NSButtonCell	{	NSColor* _on, *_off, *_mixed;	}
@property (unsafe_unretained) IBOutlet id <SNRHUDViewDelegate> delegate;
@property (readonly) 			BOOL drawCheckBoxesShaded;
@property (strong, nonatomic) NSColor *on, *off, *mixed;

@end
