/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Cocoa/Cocoa.h>

#ifdef PARTOF_AtoZ
#import "NBBModule.h"
#import "NBBSwappableControl.h"
#else
#import <NBBCore/NBBModule.h>
#import <NBBCore/NBBSwappableControl.h>
#endif
@interface NBBLaunchPad : NSControl <NBBSwappableControl>
{
	@private
	NSCell* _dragCell;
	NSCell* _dragDestCell;

	NSMutableArray* _moduleCells;
	NSMutableDictionary* _animationLayers;
	NSRectArray _cellFrames;
}
- (NSCell*) addCellForModule:(NBBModule*) module;
- (NSRect)frameForCell:(NSCell*)cell;
@end
