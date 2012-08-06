//
//  AZWindowExtend.m
//  AtoZ
//
#import "AZWindowExtend.h"




@interface NSObject(AZWindowExtend)
- (void)pointOnScreenDidChangeTo:(id)point;
// ... other methods here
@end


@implementation AZWindowExtendController
- (void)awakeFromNib
{
	NSPoint point = [NSEvent mouseLocation];
	NSString *infoText = [[NSString alloc] initWithFormat:@"x:%.2f\ny:%.2f", point.x, point.y];

//	[infoTextField bind
//	 options:]
//	[[_window infoTextField] setStringValue:infoText];
	[_window setAcceptsMouseMovedEvents:YES screen:YES];
}

@end
@implementation AZWindowExtend


- (void) awakeFromNib {
	[self setAcceptsMouseMovedEvents:YES screen:YES];

	NSPoint point = [NSEvent mouseLocation];
	NSString *infoText = [[NSString alloc] initWithFormat:@"x:%.2f\ny:%.2f", point.x, point.y];

	//	[infoTextField bind
	//	 options:]
	[_coordinates setStringValue:infoText];

}

- (void)mouseMoved:(NSEvent*)theEvent {

//	[self setFloatValue:[self floatValue] - [theEvent deltaY]];
//    NSDictionary *bindingInfo = [self infoForBinding: NSValueBinding];
//    NSObject *boundObject = [bindingInfo valueForKey:NSObservedObjectKey];
//    NSString *keyPath = [bindingInfo valueForKey:NSObservedKeyPathKey];
//    [boundObject setValue:[NSNumber numberWithFloat:[self floatValue]]
//               forKeyPath:keyPath];


	NSPoint point = [NSEvent mouseLocation];
	NSString *infoText = [[NSString alloc] initWithFormat:@"x:%.2f\ny:%.2f", point.x, point.y];
	[_coordinates setStringValue:infoText];
	// NSLog(@"x:%.2fy:%.2f", point.x, point.y);

	if([[self delegate] respondsToSelector:@selector(pointOnScreenDidChangeTo:)]) {
		[[self delegate] performSelector:@selector( pointOnScreenDidChangeTo:) withObject:[NSValue valueWithPoint:point]];
	}

}


static CFMachPortRef AUWE_portRef = NULL;
static CFRunLoopSourceRef AUWE_loopSourceRef = NULL;

static CGEventRef AUWE_OnMouseMovedFactory (
											CGEventTapProxy proxy,
											CGEventType type,
											CGEventRef event,
											void *refcon)
{
	if (kCGEventMouseMoved == type) { // paranoic
		@autoreleasepool {
			if (refcon) {
				id obj = (__bridge id)refcon;
				if ([[obj class] instancesRespondToSelector:@selector(mouseMoved:)]) {
					[obj performSelector:@selector(mouseMoved:) withObject:[NSEvent eventWithCGEvent:event]];
				}
			}
		}
	return event;
	}
}

- (void)dealloc
{
	if (AUWE_portRef) {
		CGEventTapEnable(AUWE_portRef, false);
		if (CFRunLoopContainsSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes)) {
			CFRunLoopRemoveSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes);
		}
		CFRelease(AUWE_portRef);
		CFRelease(AUWE_loopSourceRef);
		AUWE_portRef = NULL;
		AUWE_loopSourceRef = NULL;
	}
}

- (void)setAcceptsMouseMovedEvents:(BOOL)acceptMouseMovedEvents screen:(BOOL)anyWhere
{
	if (anyWhere) {
		[super setAcceptsMouseMovedEvents:NO];
		if (!AUWE_portRef) {
			if ((AUWE_portRef = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionListenOnly,
												 CGEventMaskBit(kCGEventMouseMoved), AUWE_OnMouseMovedFactory, CFBridgingRetain(self)))) {
				if ((AUWE_loopSourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, AUWE_portRef, 0))) {
					CFRunLoopAddSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes);
					CGEventTapEnable(AUWE_portRef, true);
				} else { // else error
					CFRelease(AUWE_portRef);
					AUWE_portRef = NULL;
				}
			}// else error
		}
	} else {
		if (AUWE_portRef) {
			CGEventTapEnable(AUWE_portRef, false);
			if (CFRunLoopContainsSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes)) {
				CFRunLoopRemoveSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes);
			}
			CFRelease(AUWE_portRef);
			CFRelease(AUWE_loopSourceRef);
			AUWE_portRef = NULL;
			AUWE_loopSourceRef = NULL;
		}
		[super setAcceptsMouseMovedEvents:acceptMouseMovedEvents];
	}
}

@end

/* EOF */