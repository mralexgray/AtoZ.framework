/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import "NBBWindowBase.h"

@implementation NBBWindowBase

- (void)finalizeInit
{
	[self setReleasedWhenClosed:NO];
	[self setMovableByWindowBackground:NO];
	[self setHasShadow:NO];
	[self setAnimationBehavior:NSWindowAnimationBehaviorNone]; // we want no interfearance with ours
	self.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation
{
	self = [super initWithContentRect:contentRect
							styleMask:NSBorderlessWindowMask
							  backing:NSBackingStoreBuffered
								defer:deferCreation];

    if (self) {
		[self finalizeInit];
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation screen:(NSScreen *)screen
{
	return [self initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
}

- (void)awakeFromNib
{
	[self finalizeInit];
}

- (BOOL) canBecomeKeyWindow
{
	return YES;
}

@end
