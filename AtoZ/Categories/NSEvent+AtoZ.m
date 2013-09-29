#import "NSEvent+AtoZ.h"
#include <objc/runtime.h>

typedef BOOL(^AZVisualTestCase)(NSString *instruction, SEL selector,...);

JREnumDefine(AZEvent);

@implementation NSTableView (TargetAction)  // GOOD EXAMPLE OF SWIZZLING 

@synthesizeAssociation(NSTableView, doubleActionBlock);

- (void) setDoubleAction:(SEL)method withTarget:(id)object { self.doubleAction = method;	self.target = object; }

- (void) setDoubleActionString:(NSS*)methodAsString withTarget:(id)object {	self.doubleAction = NSSelectorFromString(methodAsString); self.target = object;	}

- (void) callDoubleActionBlock 								{ self.doubleActionBlock(); }

+ (void) initialize 												{	[super initialize];	Class  nsControlClass = NSControl.class;
	
	method_exchangeImplementations(	class_getInstanceMethod(nsControlClass, @selector(   initWithCoder:)),
												class_getInstanceMethod(nsControlClass, @selector(newInitWithCoder:)));
}
- (instancetype) newInitWithCoder:(NSCoder*)c 			{
	
	NSLog(@"Swizzling tableView initWithCoder.... %s : %s", __FILE__, __LINE__);
	
	//inspired from: [h]ttp://www.mikeash.com/pyblog/custom-nscells-done-right.html
	
	IFKINDAELSE(c,NSKeyedUnarchiver, nil, return [self newInitWithCoder:c]);
	
	NSKeyedUnarchiver *unarchiver = (NSKeyedUnarchiver*)c;
	
	Class supercell = self.superclass.cellClass,  selfcell = self.class.cellClass;
	
	if (!selfcell || !supercell) return [self newInitWithCoder:c];
	
	[unarchiver setClass:selfcell forClassName:NSStringFromClass(supercell)];
	
	id aself = self;	aself = [self newInitWithCoder:c];
	
	[unarchiver setClass:supercell forClassName:NSStringFromClass(supercell)];
	
	return aself;
}
@end

@concreteprotocol (NSActionBlock)

CLANG_IGNORE(-Wmismatched-parameter-types)
CLANG_IGNORE(-Wmismatched-return-types)
SYNTHESIZE_ASC_OBJ_BLOCK(actionBlock, setActionBlock, ^{},
                         ^{ [(NSControl*)self setAction:@selector(callAssociatedBlock)  withTarget:self]; 	});

SYNTHESIZE_ASC_OBJ_BLOCK(voidActionBlock,setVoidActionBlock,^{},
								^{ [(NSControl*)self setAction:@selector(callAssociatedVoidBlock)  withTarget:self];	});

CLANG_POP
- (void) callAssociatedBlock	{  self.actionBlock ? self.actionBlock(self) : nil; }
- (void) callAssociatedVoidBlock	{ self.voidActionBlock ? self.voidActionBlock() : nil; }
@end


@implementation NSControl (AtoZ)

- (void) actionHandler:(id)e {    if (self.eventActionBlock) self.eventActionBlock([e ISKINDA:NSE.class] ? ((NSE*)e).type : (AZEvent)e, self); }

- (void(^)(AZEvent,id))eventActionBlock { return objc_getAssociatedObject(self,_cmd); }

- (void)setEventActionBlock:(void (^)(AZEvent, id))eventActionBlock{
	
	self.target = eventActionBlock == NULL ? NULL : self;   if (eventActionBlock == NULL) return;
	self.action = @selector(actionHandler:);
	objc_setAssociatedObject(self, @selector(eventActionBlock), eventActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//SYNTHESIZE_ASC_OBJ(	eventActionBlock, setEventActionBlock)


- (void) setAction:(SEL)method withTarget:(id)object;			{
	self.action = method; 	self.target = object;
}
- (void) setActionString:(NSS*)methodAsString 
				  withTarget:(id)object									{
	self.action = NSSelectorFromString(methodAsString);	self.target = object;
}

@end


@interface AZDragHandler : BaseModel
AZPROPERTY(NSE, nonatomic, *click, *now, *mouseUp);
AZPROPERTY(NSP, readonly,  dragStart, delta);
AZPROPERTY(void(^handler)(AZDragHandler*), copy);
@end

@implementation AZDragHandler { id internalHandler; }
+ (instancetype) handleClick:(NSE*)click withBlock:(void(^)(AZDragHandler*))block {
	AZDragHandler* handler = self.new;
	handler.click = click;
	handler.handler = block;
	return handler;
}
- (NSP) delta 		{  return AZSubtractPoints(_click.locationInWindow, _now.locationInWindow); }
- (NSP) dragStart {  return _click.locationInWindow; }
- (void) setClick:(NSEvent *)click {

	internalHandler =	[NSEVENTLOCALMASK:NSLeftMouseUpMask|NSLeftMouseDraggedMask|NSLeftMouseDown handler:^NSEvent *(NSEvent *e){

		return e;
	}];
}
@end

static NSMD *scrolls = nil;	static NSE *theDrag;
@implementation NSEvent (AtoZ)
- (NSSZ) scrollOffsetInView:(NSV*)view 												{

	if (!scrolls) scrolls = [NSMutableDictionary new];
	
	NSSize x = ([scrolls objectForKey:view.description]) ? [scrolls[view.description] sizeValue ] : NSZeroSize;
	x.width += self.deltaX;
	x.height += self.deltaY;
	scrolls[view.description] = AZVsize(x);
	return x;
}
-  (NSR) magnifyRect:(NSR)rect 															{
	
	NSRect originalRect,newRect; originalRect = newRect = rect;
	newRect.size.height 	= originalRect.size.height * ([self magnification] + 1.0);
	newRect.size.width 	= originalRect.size.width 	* ([self magnification] + 1.0);
//	[self setFrameSize:size];
	CGFloat deltaX = (originalRect.size.width  - newRect.size.width) / 2;
	CGFloat deltaY = (originalRect.size.height  - newRect.size.height) / 2;
	newRect.origin.x = newRect.origin.x + deltaX;
	newRect.origin.y = newRect.origin.y + deltaY;
	return newRect;	
}
+ (void) whileDragging:(void(^)(NSE*click, NSE*drag)) block						{
	__block id handler = [self addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^NSE*(NSE *click){
//		NSLog(@"click caller at %@", AZString(click.locationInWindow));
		theDrag = [click dragHandlerForClickWithBlock:block];
		return click;
	}];
	[self addLocalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^NSEvent *(NSEvent *e) {
		theDrag = nil;
		handler = nil;
		return e;
	}];
}
-   (id) dragHandlerForClickWithBlock:(void(^)(NSE*click, NSE*drag)) block	{
	return [self.class addLocalMonitorForEventsMatchingMask:NSLeftMouseDraggedMask handler:^NSEvent *(NSEvent *drag) {
//		drag = [NSApp nextEventMatchingMask:NSLeftMouseDraggedMask untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES];
//			[NSApp discardEventsMatchingMask:NSAnyEventMask beforeEvent:drag];
//			if ( drag.type == NSLeftMouseDragged )
		block(self, drag);
//			else if ( click.type == NSLeftMouseUp )
			return drag;
	}];
}
+ (void) shiftClick:(void(^)(void))block 												{

	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler: ^(NSEvent *event){
		NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
		if (flags ==  NSShiftKeyMask)   block(); ////NSControlKeyMask +
		return event;
	}];
}

@end

/*
static NSString *NSTVDOUBLEACTIONBLOCKKEY = @"com.mrgray.NSTV.double.action.block";

- (void)setDoubleActionBlock:(NSControlVoidActionBlock)block	{
	[self setDoubleActionString:@"callDoubleActionBlock" withTarget:self];
	[self setAssociatedValue:block forKey: NSTVDOUBLEACTIONBLOCKKEY policy:OBJC_ASSOCIATION_COPY];
}


insideDrag dragBlock = ^void(NSE *e, NSP start, whileDragging dragaction) {

	NSLog(@"Inside dragblock!  Yay!");
	while ( ( e = [NSApp nextEventMatchingMask: MOUSEDRAGGING untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES] ) && ( e.type != MOUSEUP) ) {
		@autoreleasepool {
			dragaction();
		}
	}
};

+(void) dragBlock:(void(^)(NSP delta))block {

	__block NSP ref;
	[self addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^NSE*(NSE *click){

		NSLog(@"Inside dragblock! Click:%@ Yay!", AZString(ref = click.locationInWindow));
//		while ( ( click = [NSApp nextEventMatchingMask: MOUSEDRAGGING untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES] ) && ( e.type != MOUSEUP) ) {
//		@autoreleasepool {
//			block (AZSubtractPoints(ref,click.locationInWindow))
//		}
//	}
//	}];
		return e;
	}];
//}


+ (whileDragging)dragBlock:(NSE*)e;	{ NSPoint start = e.locationInWindow;	return  whileDragging:(e, start);	}
	__block NSP down;
		down = d.locationInWindow;
		[self addLocalMonitorForEventsMatchingMask:NSLeftMouseDraggedMask handler:^(NSE *drag) {
		NSE *drag;
		while ( ( drag = [NSApp nextEventMatchingMask: NSLeftMouseDraggedMask untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES] )
		&&
		 ( drag.type != MOUSEUP ))  {
			@autoreleasepool {
				block(click, drag);
			}
			return drag;
			}];
		}
		return click;

	}];

- (void)mouseDown:(NSEvent *)theEvent
{
	BOOL keepOn = YES;
	BOOL isInside = YES;
	NSPoint mouseLoc;

	do {
		mouseLoc = [self convertPoint:[theEvent mouseLocationInWindow
									   fromView:nil]];
		isInside = [self mouse:mouseLoc inRect:[self bounds]];

		switch ([theEvent type]) {
			case NSLeftMouseDragged:
				[self highlight:isInside];
				break;
			case NSLeftMouseUp:
				if (isInside) [self doSomethingSignificant];
				[self highlight:NO];
				keepOn = NO;
				break;
			default:
//				 Ignore any other kind of event.  * /
				break;
		}

		theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask |
					NSLeftMouseDraggedMask];

	}while (keepOn);

	return;
}

- (NSControlActionBlock)actionBlock									{//	NSControlActionBlock theBlock =
	return (NSControlActionBlock)objc_getAssociatedObject(self,(__bridge const void *)NSCONTROLBLOCKACTIONKEY);
//	return(theBlock);
}
- (void)setActionBlock:(NSControlActionBlock)inBlock			{
	self.target = self;
	self.action = @selector(callAssociatedBlock:);
	[self setAssociatedValue:inBlock forKey: NSCONTROLBLOCKACTIONKEY policy:OBJC_ASSOCIATION_COPY];
}
- (NSControlVoidActionBlock) voidActionBlock 					{	return (NSControlVoidActionBlock)objc_getAssociatedObject(self,(__bridge const void *)NSCONTROLVOIDBLOCKACTIONKEY);}
- (void)setVoidActionBlock:(NSControlVoidActionBlock)inBlock{
	[self setActionString:@"callAssociatedVoidBlock" withTarget:self];
	[self setAssociatedValue:inBlock forKey: NSCONTROLVOIDBLOCKACTIONKEY policy:OBJC_ASSOCIATION_COPY];
}
static NSString *NSCONTROLBLOCKACTIONKEY = @"com.mrgray.NSControl.block";
static NSString *NSCONTROLVOIDBLOCKACTIONKEY = @"com.mrgray.NSControl.voidBlock";

*/
