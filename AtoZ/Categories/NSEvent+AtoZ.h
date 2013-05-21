//
//  NSEvent+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/23/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>




JREnumDeclare(AZEvent, AZEventLeftMouseDown = 1,
				   AZEventLeftMouseUp,
				   AZEventRightMouseDown,
				   AZEventRightMouseUp,
				   AZEventMouseMoved,
				   AZEventLeftMouseDragged,
				   AZEventRightMouseDragged,
				   AZEventMouseEntered,
				   AZEventMouseExited,
				   AZEventKeyDown,
				   AZEventKeyUp,
				   AZEventFlagsChanged,
				   AZEventAppKitDefined,
				   AZEventSystemDefined,
				   AZEventApplicationDefined,
				   AZEventPeriodic,
				   AZEventCursorUpdate,
				   AZEventScrollWheel,
				   AZEventTabletPoint,
				   AZEventTabletProximity,
				   AZEventOtherMouseDown,
				   AZEventOtherMouseUp,
				   AZEventOtherMouseDragged,
				   AZEventEventTypeGesture,
				   AZEventEventTypeMagnify,
				   AZEventEventTypeSwipe,
				   AZEventEventTypeRotate,
				   AZEventEventTypeBeginGesture,
				   AZEventTypeEndGesture);

typedef void(^NSControlVoidActionBlock)(void);

typedef void(^NSControlActionBlock)(id inSender);

@interface NSControl (AtoZ)

@property (readwrite, nonatomic, copy) NSControlActionBlock actionBlock;
@property (readwrite, nonatomic, copy) NSControlVoidActionBlock voidActionBlock;

- (void) setAction:(SEL)method withTarget:(id)object;
- (void) setActionString:(NSS*)methodasString withTarget:(id)object;
@end

//typedef void (^whileDragging)(void);
//typedef void (^insideDrag)(NSE*, NSP, whileDragging);
typedef void (^EventBlock)(NSE* e);

@interface NSEvent (AtoZ)


/*	- (void) scrollWheel:(NSEvent *)theEvent	{	self.offset = [theEvent scrollOffsetInView:self];	
																						    [self setNeedsDisplay:YES];	} */
- (NSSZ) scrollOffsetInView:(NSV*)view;

/*	- (void)magnifyWithEvent:(NSEvent *)event {	[self setFrame:[event magnifyRect:self.frame]]; */
- (NSR) magnifyRect:(NSR)rect;




//- (whileDragging)dragBlock:(NSE*)e;
+ (void)whileDragging:(void(^)(NSE* click, NSE*drag))block;
+ (void) shiftClick:(void(^)(void))block;
//+ (NSE*) whileDragging:(whileDragging)whileDraggingBlock;

@end


@interface NSTV (TargetAction)

@property (readwrite, nonatomic, copy) NSControlVoidActionBlock doubleActionBlock;

- (void) setDoubleAction:(SEL)method withTarget:(id)object;
- (void) setDoubleActionString:(NSS*)methodasString withTarget:(id)object;
- (void) setDoubleActionBlock:(NSControlVoidActionBlock)block;

@end
