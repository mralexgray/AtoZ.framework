//
//  AZOverlayView.m
//  AZOverlayView
//
//  Created by Mikkel Eide Eriksen on 25/01/12.
//  Copyright (c) 2012 Mikkel Eide Eriksen. All rights reserved.
//


#import "AZOverlay.h"
//#import "AtoZ.h"

#pragma mark -
#pragma mark Helper class extension

enum {
    AZNoCorner = -1,
    AZNorthEastCorner,
    AZNorthWestCorner,
    AZSouthEastCorner,
    AZSouthWestCorner
};
typedef NSUInteger AZCorner;

@interface AZOverlayView ()

//initialization
- (void)initialSetup;
- (void)drawOverlays;

//helpers
- (void)setMouseForPoint:(NSPoint)point;
- (CGPathRef)newRectPathWithSize:(NSSize)size handles:(BOOL)handles;
- (id)layerAtPoint:(NSPoint)point;
- (AZCorner)cornerOfLayer:(CALayer *)layer atPoint:(NSPoint)point;
- (BOOL)rect:(NSRect)rect isValidForLayer:(CALayer *)layer;
- (void)draggedFrom:(NSPoint)startPoint to:(NSPoint)endPoint done:(BOOL)done;

//maybe these should be put in categories on their respective objects?
//NSCursor:
- (NSCursor *)northWestSouthEastResizeCursor;
- (NSCursor *)northEastSouthWestResizeCursor;
//IKImageView:
- (NSPoint)convertWindowPointToImagePoint:(NSPoint)windowPoint;
//CAShapeLayer:
- (CAShapeLayer *)layerWithRect:(NSRect)rect handles:(BOOL)handles selected:(BOOL)selected;

@end

#pragma mark -
#pragma mark Implementation

@implementation AZOverlayView {
    __weak id __AZ_overlayDelegate;
    __weak id __AZ_overlayDataSource;
    
    AZState __AZ_state;
    CALayer *__AZ_topLayer;
    
    //properties
    CGColorRef __AZ_overlayFillColor;
    CGColorRef __AZ_overlayBorderColor;
    CGColorRef __AZ_overlaySelectionFillColor;
    CGColorRef __AZ_overlaySelectionBorderColor;
    CGFloat __AZ_overlayBorderWidth;
    
    __weak id __AZ_target;
    SEL __AZ_action;
    SEL __AZ_doubleAction;
    SEL __AZ_rightAction;
    
    BOOL __AZ_allowsCreatingOverlays;
    BOOL __AZ_allowsModifyingOverlays;
    BOOL __AZ_allowsDeletingOverlays;
    BOOL __AZ_allowsOverlappingOverlays;
    
    BOOL __AZ_allowsOverlaySelection;
    BOOL __AZ_allowsEmptyOverlaySelection;
    BOOL __AZ_allowsMultipleOverlaySelection;
    
    //internal helper ivars
    CGFloat __AZ_handleWidth;
    CGFloat __AZ_handleOffset;
    NSCursor *__AZ_northWestSouthEastResizeCursor;
    NSCursor *__AZ_northEastSouthWestResizeCursor;
    
    //events
    NSPoint __AZ_mouseDownPoint;
    
    //temp vals
    CAShapeLayer *__AZ_activeLayer;
    AZCorner __AZ_activeCorner;
    NSPoint __AZ_activeOrigin;
    NSSize __AZ_activeSize;
    CGFloat __AZ_xOffset;
    CGFloat __AZ_yOffset;
    NSInvocation *__AZ_singleClickInvocation;
    
    //cache
    id __AZ_overlayCache;
    NSMutableArray *__AZ_selectedOverlays;
    NSInteger __AZ_clickedOverlay;
}

#pragma mark Initialization

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self) {
        DLog(@"init");
        __AZ_state = AZIdleState;
        
        //default property values:
        __AZ_overlayFillColor = CGColorCreateGenericRGB(0.0f, 0.0f, 1.0f, 0.5f);
        __AZ_overlayBorderColor = CGColorCreateGenericRGB(0.0f, 0.0f, 1.0f, 1.0f);
        __AZ_overlaySelectionFillColor = CGColorCreateGenericRGB(0.0f, 1.0f, 0.0f, 0.5f);
        __AZ_overlaySelectionBorderColor = CGColorCreateGenericRGB(0.0f, 1.0f, 0.0f, 1.0f);
        __AZ_overlayBorderWidth = 3.0f;
        
        __AZ_allowsCreatingOverlays = YES;
        __AZ_allowsModifyingOverlays = YES;
        __AZ_allowsDeletingOverlays = YES;
        __AZ_allowsOverlappingOverlays = NO;
        
        __AZ_allowsOverlaySelection = YES;
        __AZ_allowsEmptyOverlaySelection = YES;
        __AZ_allowsMultipleOverlaySelection = YES;
        
        __AZ_handleWidth = __AZ_overlayBorderWidth * 2.0f;
        __AZ_handleOffset = (__AZ_overlayBorderWidth / 2.0f) + 1.0f;
        
        __AZ_overlayCache = [NSMutableArray arrayWithCapacity:0];
        __AZ_selectedOverlays = [NSMutableArray arrayWithCapacity:0];
        __AZ_clickedOverlay = -1;
        
        __AZ_activeCorner = AZNoCorner;
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    AZLOG($(@"overlayDelegate: %@", __AZ_overlayDelegate));
    AZLOG($(@"overlayDataSource: %@", __AZ_overlayDataSource));
	
    [self performSelector:@selector(initialSetup) withObject:nil afterDelay:0.0f];
}

- (void)initialSetup
{
    __AZ_topLayer = [CALayer layer];
    
    [__AZ_topLayer setFrame:NSMakeRect(0.0f, 0.0f, [self imageSize].width, [self imageSize].height)];
    [__AZ_topLayer setName:@"topLayer"];
    
    [self reloadData];
    
    NSTrackingArea *fullArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect 
                                                            options:(NSTrackingCursorUpdate | NSTrackingActiveInKeyWindow | NSTrackingInVisibleRect) 
                                                              owner:self 
                                                           userInfo:@{@"layer": __AZ_topLayer}];
    [self addTrackingArea:fullArea];
    
    [self setOverlay:__AZ_topLayer forType:IKOverlayTypeImage];
}

- (void)reloadData
{
    if (__AZ_overlayDataSource) {
        AZLOG($(@"Setting up overlays from overlayDataSouce: %@", __AZ_overlayDataSource));
        
        NSUInteger count = [__AZ_overlayDataSource numberOfOverlaysInOverlayView:self];
        
        AZLOG($(@"Number of overlays to create: %lu", count));
        
        __AZ_overlayCache = [NSMutableArray arrayWithCapacity:count];
        for (NSUInteger i = 0; i < count; i++) {
            [__AZ_overlayCache addObject:[__AZ_overlayDataSource overlayView:self overlayObjectAtIndex:i]];
        }
    }
    
    [self drawOverlays];
}

- (void)drawOverlays
{
    AZLOG(@"start");
//    if (![self allowsEmptyOverlaySelection] && __AZ_selectedOverlays.count == 0 && __AZ_overlayCache.count > 0) {
        if ([__AZ_overlayCache respondsToSelector:@selector(lastObject)]) {
            __AZ_selectedOverlays = [NSMutableArray arrayWithObject:[__AZ_overlayCache lastObject]];
        } else {
            __AZ_selectedOverlays = [NSMutableArray arrayWithObject:[__AZ_overlayCache anyObject]];
        }
//    }

    [__AZ_topLayer setSublayers:@[]];
    
    __weak AZOverlayView *weakSelf = self;
    [__AZ_overlayCache enumerateObjectsUsingBlock:^(id overlayObject, NSUInteger i, BOOL *stop){
        AZOverlayView *strongSelf = weakSelf;
        AZLOG($(@"Creating layer #%lu", i));
        
        NSRect rect = NSZeroRect;
        if ([overlayObject respondsToSelector:@selector(rectValue)]) {
            rect = [overlayObject rectValue];
        } else if ([overlayObject respondsToSelector:@selector(rect)]) {
            rect = [overlayObject rect];
        } else {
            @throw [NSException exceptionWithName:@"AZOverlayObjectHasNoRect"
                                           reason:@"Objects given to AZOverlayView must respond to -(NSRect)rectValue or -(NSRect)rect"
                                         userInfo:nil];
        }
        
        CALayer *layer = [strongSelf layerWithRect:rect 
                                           handles:(__AZ_state == AZModifyingState)
                                          selected:[__AZ_selectedOverlays containsObject:overlayObject]];
        
        [layer setValue:[NSNumber numberWithInteger:i] forKey:@"AZOverlayNumber"];
        [layer setValue:overlayObject forKey:@"AZOverlayObject"];
        
        AZLOG($(@"Created layer: %@", layer));
        
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[strongSelf convertImageRectToViewRect:rect] 
                                                            options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingCursorUpdate | NSTrackingActiveInKeyWindow) 
                                                              owner:self 
                                                           userInfo:@{@"layer": layer}];
        [self addTrackingArea:area];
        [layer setValue:area forKey:@"AZOverlayTrackingArea"];
        
        [__AZ_topLayer addSublayer:layer];
    }];
}

#pragma mark Deallocation

- (void)dealloc
{
    [self setOverlayDelegate:nil];
    [self setOverlayDataSource:nil];
    
    CFRelease(__AZ_overlayFillColor);
    CFRelease(__AZ_overlayBorderColor);
    CFRelease(__AZ_overlaySelectionFillColor);
    CFRelease(__AZ_overlaySelectionBorderColor);
}

#pragma mark State

- (BOOL)enterState:(AZState)_state
{
    //check for allowances
    if (_state == AZCreatingState && !__AZ_allowsCreatingOverlays) {
        return NO;
    } else if (_state == AZModifyingState && !__AZ_allowsModifyingOverlays) {
        return NO;
    } else if (_state == AZDeletingState && !__AZ_allowsDeletingOverlays) {
        return NO;
    } else {
        DLog(@"%lu => %lu", __AZ_state, _state);
        __AZ_state = _state;
        [self setNeedsDisplay:YES];
        return YES;
    }
}

#pragma mark Selection

- (void)selectOverlayIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend
{
    if ([indexes count] == 0) {
        return;
    }
    if (extend) {
        [__AZ_selectedOverlays addObjectsFromArray:[__AZ_overlayCache objectsAtIndexes:indexes]];
    } else {
        __AZ_selectedOverlays = [[__AZ_overlayCache objectsAtIndexes:indexes] mutableCopy];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AZOverlayViewSelectionDidChangeNotification object:self];
}

- (NSInteger)selectedOverlayIndex
{
    NSIndexSet *selected = [self selectedOverlayIndexes];
    if ([selected count] >= 1) {
        return [selected lastIndex];
    } else {
        return -1;
    }
}

- (NSIndexSet *)selectedOverlayIndexes
{
    return [__AZ_overlayCache indexesOfObjectsPassingTest:^(id overlayObject, NSUInteger i, BOOL *stop){
        return [__AZ_selectedOverlays containsObject:overlayObject];
    }];
}

- (NSArray *)selectedOverlays
{
    return __AZ_selectedOverlays;
}

- (void)deselectOverlay:(NSInteger)overlayIndex
{
    [__AZ_selectedOverlays removeObject:__AZ_overlayCache[overlayIndex]];
    [[NSNotificationCenter defaultCenter] postNotificationName:AZOverlayViewSelectionDidChangeNotification object:self];
}

- (NSInteger)numberOfSelectedOverlays
{
    return [__AZ_selectedOverlays count];
}

- (BOOL)isOverlaySelected:(NSInteger)overlayIndex
{
    return [__AZ_selectedOverlays containsObject:__AZ_overlayCache[overlayIndex]];
}

- (IBAction)selectAllOverlays:(id)sender
{
    __AZ_selectedOverlays = [__AZ_overlayCache mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:AZOverlayViewSelectionDidChangeNotification object:self];
}

- (IBAction)deselectAllOverlays:(id)sender
{
    __AZ_selectedOverlays = [NSMutableArray arrayWithCapacity:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:AZOverlayViewSelectionDidChangeNotification object:self];
}

#pragma mark Mouse events

- (void)mouseDown:(NSEvent *)theEvent
{
    __AZ_mouseDownPoint = [self convertWindowPointToImagePoint:[theEvent locationInWindow]];
    
    [super mouseDown:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint mouseUpPoint = [self convertWindowPointToImagePoint:[theEvent locationInWindow]];
    CGFloat epsilonSquared = 0.025;
    
    CGFloat dx = __AZ_mouseDownPoint.x - mouseUpPoint.x, dy = __AZ_mouseDownPoint.y - mouseUpPoint.y;
    BOOL pointsAreEqual = (dx * dx + dy * dy) < epsilonSquared;
    
    if ((__AZ_state == AZCreatingState || __AZ_state == AZModifyingState) && !pointsAreEqual) {
        [self draggedFrom:__AZ_mouseDownPoint to:mouseUpPoint done:NO];
    } else {
        [super mouseDragged:theEvent];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint mouseUpPoint = [self convertWindowPointToImagePoint:[theEvent locationInWindow]];
    CGFloat epsilonSquared = 0.025;
    
    CGFloat dx = __AZ_mouseDownPoint.x - mouseUpPoint.x, dy = __AZ_mouseDownPoint.y - mouseUpPoint.y;
    BOOL pointsAreEqual = (dx * dx + dy * dy) < epsilonSquared;
    
    CALayer *hitLayer = [self layerAtPoint:mouseUpPoint];
    
    if (__AZ_state == AZDeletingState && [self allowsDeletingOverlays] && [hitLayer valueForKey:@"AZOverlayObject"]) {
        id overlayObject = [hitLayer valueForKey:@"AZOverlayObject"];
        [__AZ_overlayDelegate overlayView:self didDeleteOverlay:overlayObject];
        [__AZ_selectedOverlays removeObject:overlayObject];
        [self removeTrackingArea:[hitLayer valueForKey:@"AZOverlayTrackingArea"]];
    } else if (__AZ_state == AZIdleState && [hitLayer valueForKey:@"AZOverlayObject"]) {
        if ([self allowsOverlaySelection]) {
            NSUInteger layerNumber = [[hitLayer valueForKey:@"AZOverlayNumber"] integerValue];
            DLog(@"checking select with %lu", layerNumber);
            BOOL multiAttempt = ([theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSShiftKeyMask || ([theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask;
            if ([self isOverlaySelected:layerNumber]) {
                if (multiAttempt && ([self numberOfSelectedOverlays] > 1 || [self allowsEmptyOverlaySelection])) {
                    DLog(@"deselected");
                    [self deselectOverlay:layerNumber];
                    [[NSNotificationCenter defaultCenter] postNotificationName:AZOverlayViewSelectionDidChangeNotification object:self];
                }
            } else {
                [self selectOverlayIndexes:[NSIndexSet indexSetWithIndex:layerNumber] 
                      byExtendingSelection:(multiAttempt && [self allowsMultipleOverlaySelection])];
                [[NSNotificationCenter defaultCenter] postNotificationName:AZOverlayViewSelectionDidChangeNotification object:self];
            }
            DLog(@"current selection: %@", __AZ_selectedOverlays);
            [self drawOverlays];
        }
        if (__AZ_action || __AZ_doubleAction) {
            __AZ_clickedOverlay = [__AZ_overlayCache indexOfObject:[hitLayer valueForKey:@"AZOverlayObject"]];
            DLog(@"click!");
            DLog(@"__AZ_action: %@", NSStringFromSelector(__AZ_action));
            DLog(@"__AZ_doubleAction: %@", NSStringFromSelector(__AZ_doubleAction));
            if ([theEvent clickCount] == 1 && __AZ_action) {
                [__AZ_target performSelector:__AZ_action withObject:nil afterDelay:[NSEvent doubleClickInterval]];
            } else if ([theEvent clickCount] == 2 && __AZ_doubleAction) {
                DLog(@"Cancelling single click: %@", __AZ_singleClickInvocation);
                [NSRunLoop cancelPreviousPerformRequestsWithTarget:__AZ_target];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [__AZ_target performSelector:__AZ_doubleAction];
#pragma clang diagnostic pop
            } else {
                [super mouseUp:theEvent];
            }
        }
    } else if ((__AZ_state == AZCreatingState || __AZ_state == AZModifyingState) && !pointsAreEqual) {
        [self draggedFrom:__AZ_mouseDownPoint to:mouseUpPoint done:YES];
    } else {
        [super mouseUp:theEvent];
    }
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    NSPoint mouseUpPoint = [self convertWindowPointToImagePoint:[theEvent locationInWindow]];
    
    CALayer *hitLayer = [self layerAtPoint:mouseUpPoint];
    
    if (__AZ_state == AZIdleState && [hitLayer valueForKey:@"AZOverlayObject"] && __AZ_rightAction) {
        __AZ_clickedOverlay = [__AZ_overlayCache indexOfObject:[hitLayer valueForKey:@"AZOverlayObject"]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [__AZ_target performSelector:__AZ_rightAction];
#pragma clang diagnostic pop
    } else {
        [super mouseUp:theEvent];
    }
}

- (void)cursorUpdate:(NSEvent *)theEvent
{
    [self setMouseForPoint:[self convertWindowPointToImagePoint:[theEvent locationInWindow]]];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [self setMouseForPoint:[self convertWindowPointToImagePoint:[theEvent locationInWindow]]];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self setMouseForPoint:[self convertWindowPointToImagePoint:[theEvent locationInWindow]]];
}

#pragma mark Key events

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
    //prevents "beep" on button click.
    [super keyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent
{
    id selection = [__AZ_selectedOverlays lastObject];
    DLog(@"selection: %@", selection);
    if (selection == nil) {
        return;
    }
    
    CGPoint center = NSMakePoint(NSMidX([selection rectValue]), NSMidY([selection rectValue]));
    
    id bestCandidate = nil;
    CGFloat bestDistance = MAXFLOAT;
    
    for (CALayer *sublayer in [__AZ_topLayer sublayers]) {
        if (selection == sublayer) {
            continue; //don't compare against oneself
        }
        CGFloat dist = AZDistance(center, NSMakePoint(NSMidX([sublayer frame]), NSMidY([sublayer frame])));
        switch ([theEvent keyCode]) {
            case 0x7B: { //left arrow
                if (dist < bestDistance && NSMidX([sublayer frame]) < center.x) {
                    bestCandidate = sublayer;
                    bestDistance = dist;
                }
            }
                break;
            case 0x7C: { //right arrow
                if (dist < bestDistance && NSMidX([sublayer frame]) > center.x) {
                    bestCandidate = sublayer;
                    bestDistance = dist;
                }
            }
                break;
            case 0x7D: { //down arrow
                if (dist < bestDistance && NSMidY([sublayer frame]) < center.y) {
                    bestCandidate = sublayer;
                    bestDistance = dist;
                }
            }
                break;
            case 0x7E: { //up arrow
                if (dist < bestDistance && NSMidY([sublayer frame]) > center.y) {
                    bestCandidate = sublayer;
                    bestDistance = dist;
                }
            }
                break;
            default:;
                break;
        }
    }
    
    if (bestCandidate) {
        __AZ_selectedOverlays = [NSMutableArray arrayWithObject:[bestCandidate valueForKey:@"AZOverlayObject"]];
        [self drawOverlays];
    }
    
    [super keyUp:theEvent];
}

#pragma mark Other events

- (void)selectAll:(id)sender
{
    [self selectAllOverlays:sender];
    [self drawOverlays];
}

#pragma mark Helpers

//Weird that NSCursor doesn't provide these types of cursor...
- (NSCursor *)northWestSouthEastResizeCursor
{
    if (__AZ_northWestSouthEastResizeCursor == nil) {
        __AZ_northWestSouthEastResizeCursor = [[NSCursor alloc] initWithImage:[[NSImage alloc] initWithContentsOfFile:@"/System/Library/Frameworks/WebKit.framework/Versions/A/Frameworks/WebCore.framework/Versions/A/Resources/northWestSouthEastResizeCursor.png"] hotSpot:NSMakePoint(8.0f, 8.0f)];
    }
    return __AZ_northWestSouthEastResizeCursor;
}

- (NSCursor *)northEastSouthWestResizeCursor
{
    if (__AZ_northEastSouthWestResizeCursor == nil) {
        __AZ_northEastSouthWestResizeCursor = [[NSCursor alloc] initWithImage:[[NSImage alloc] initWithContentsOfFile:@"/System/Library/Frameworks/WebKit.framework/Versions/A/Frameworks/WebCore.framework/Versions/A/Resources/northEastSouthWestResizeCursor.png"] hotSpot:NSMakePoint(8.0f, 8.0f)];
    }
    return __AZ_northEastSouthWestResizeCursor;
}

- (void)setMouseForPoint:(NSPoint)point
{
    //Unfortunately necessary to do it this way since I don't get -cursorUpdate: messages when the mouse leaves a layer and goes back to the topLayer.
    
    CALayer *layer = [self layerAtPoint:point];
    
    if (__AZ_state == AZCreatingState && layer == __AZ_topLayer) {
        DLog(@"layer %@ topLayer %@", layer, __AZ_topLayer);
        [[NSCursor crosshairCursor] set];
    } else if (__AZ_state == AZModifyingState && layer != __AZ_topLayer) {
        AZCorner corner = [self cornerOfLayer:layer atPoint:point];
        if (corner == AZNorthEastCorner || corner == AZSouthWestCorner) {
            [[self northEastSouthWestResizeCursor] set];
        } else if (corner == AZNorthWestCorner || corner == AZSouthEastCorner) {
            [[self northWestSouthEastResizeCursor] set];
        } else { //AZNoCorner
            [[NSCursor openHandCursor] set];
        }
    } else if (__AZ_state == AZDeletingState && layer != __AZ_topLayer) {
        [[NSCursor disappearingItemCursor] set];
    } else {
        [[NSCursor arrowCursor] set];
    }
}

- (NSPoint)convertWindowPointToImagePoint:(NSPoint)windowPoint
{
    DLog(@"windowPoint: %@", NSStringFromPoint(windowPoint));
    NSPoint imagePoint = [self convertViewPointToImagePoint:[self convertPoint:windowPoint fromView:[[self window] contentView]]];
    DLog(@"imagePoint: %@", NSStringFromPoint(imagePoint));
    return imagePoint;
}

- (CGPathRef)newRectPathWithSize:(NSSize)size handles:(BOOL)handles
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, NSMakeRect(0.0f, 0.0f, size.width, size.height));
    
    if (handles) {
        CGPathAddEllipseInRect(path, NULL, NSMakeRect(-__AZ_handleOffset, -__AZ_handleOffset, __AZ_handleWidth, __AZ_handleWidth));
        CGPathAddEllipseInRect(path, NULL, NSMakeRect(-__AZ_handleOffset, size.height - __AZ_handleOffset, __AZ_handleWidth, __AZ_handleWidth));
        CGPathAddEllipseInRect(path, NULL, NSMakeRect(size.width - __AZ_handleOffset, -__AZ_handleOffset, __AZ_handleWidth, __AZ_handleWidth));
        CGPathAddEllipseInRect(path, NULL, NSMakeRect(size.width - __AZ_handleOffset, size.height - __AZ_handleOffset, __AZ_handleWidth, __AZ_handleWidth));
    }
    
    return path;
}

- (CAShapeLayer *)layerWithRect:(NSRect)rect handles:(BOOL)handles selected:(BOOL)selected
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    [layer setFrame:rect];
    CGPathRef path = [self newRectPathWithSize:rect.size handles:handles];
    [layer setPath:path];
    CFRelease(path);
    
    if (selected) {
        DLog(@"drawing selected");
        [layer setFillColor:__AZ_overlaySelectionFillColor];
        [layer setStrokeColor:__AZ_overlaySelectionBorderColor];
    } else {
        [layer setFillColor:__AZ_overlayFillColor];
        [layer setStrokeColor:__AZ_overlayBorderColor];
    }
    [layer setLineWidth:__AZ_overlayBorderWidth];
    [layer setNeedsDisplayOnBoundsChange:YES];
    
    return layer;
}

- (id)layerAtPoint:(NSPoint)point
{
    CALayer *rootLayer = [self overlayForType:IKOverlayTypeImage];
    CALayer *hitLayer = [rootLayer hitTest:[self convertImagePointToViewPoint:point]];
    
    if (hitLayer != __AZ_topLayer) {
        DLog(@"hitLayer for obj %@: %@", [hitLayer valueForKey:@"AZOverlayObject"], hitLayer);
    }
    
    return hitLayer;
}

- (AZCorner)cornerOfLayer:(CALayer *)layer atPoint:(NSPoint)point
{
    NSRect frame = [layer frame];
    
    CGFloat tolerance = __AZ_handleWidth * 3.0f;
    
    NSPoint swPoint = NSMakePoint(frame.origin.x, 
                                  frame.origin.y);
    
    NSPoint nwPoint = NSMakePoint(frame.origin.x, 
                                  frame.origin.y + frame.size.height);
    
    NSPoint nePoint = NSMakePoint(frame.origin.x + frame.size.width, 
                                  frame.origin.y + frame.size.height);
    
    NSPoint sePoint = NSMakePoint(frame.origin.x + frame.size.width, 
                                  frame.origin.y);
    
    if (AZDistance(point, nePoint) <= tolerance) {
        return AZNorthEastCorner;
    } else if (AZDistance(point, nwPoint) <= tolerance) {
        return AZNorthWestCorner;
    } else if (AZDistance(point, sePoint) <= tolerance) {
        return AZSouthEastCorner;
    } else if (AZDistance(point, swPoint) <= tolerance) {
        return AZSouthWestCorner;
    } else {
        return AZNoCorner;
    }
}

- (BOOL)rect:(NSRect)rect isValidForLayer:(CALayer *)layer
{
    if (rect.origin.x < 0.0f) {
        return NO;
    } else if (rect.origin.y < 0.0f) {
        return NO;
    } else if (rect.origin.x + rect.size.width > [self imageSize].width) {
        return NO;
    } else if (rect.origin.y + rect.size.height > [self imageSize].height) {
        return NO;
    }
    
    if (![self allowsOverlappingOverlays]) {
        for (CALayer *sublayer in [__AZ_topLayer sublayers]) {
            if (layer == sublayer) {
                continue; //don't compare against oneself
            }
            NSRect frameRect = [sublayer frame];
            if (NSIntersectsRect(rect, frameRect)) {
                DLog(@"layer %@ (rect %@) would intersect layer #%lu %@: %@", layer, NSStringFromRect(rect), [[sublayer valueForKey:@"AZOverlayNumber"] integerValue], sublayer, NSStringFromRect(rect));
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)draggedFrom:(NSPoint)startPoint to:(NSPoint)endPoint done:(BOOL)done
{
    DLog(@"from %@ to %@", NSStringFromPoint(startPoint), NSStringFromPoint(endPoint));
    
    if (__AZ_state == AZCreatingState && [self allowsCreatingOverlays]) {
        DLog(@"creating");
        if (__AZ_activeLayer == nil) {
            __AZ_activeLayer = [self layerWithRect:NSZeroRect handles:YES selected:YES];
            
            [__AZ_topLayer addSublayer:__AZ_activeLayer];
        }
        
        NSPoint origin = NSMakePoint(fmin(startPoint.x, endPoint.x), fmin(startPoint.y, endPoint.y));
        NSPoint end = NSMakePoint(fmax(startPoint.x, endPoint.x), fmax(startPoint.y, endPoint.y));
        NSSize size = NSMakeSize(end.x - origin.x, end.y - origin.y);
        NSRect newRect = NSMakeRect(origin.x, origin.y, size.width, size.height);
        
        BOOL validLocation = [self rect:newRect isValidForLayer:__AZ_activeLayer];
        
        if (validLocation) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.0f];
            [__AZ_activeLayer setFrame:newRect];
            CGPathRef path = [self newRectPathWithSize:newRect.size handles:YES];
            [__AZ_activeLayer setPath:path];
            CFRelease(path);
            [CATransaction commit];
        }
        
        if (done) {
            DLog(@"done creating: %@", NSStringFromRect([__AZ_activeLayer frame]));
            [__AZ_overlayDelegate overlayView:self didCreateOverlay:[__AZ_activeLayer frame]];
            [__AZ_activeLayer removeFromSuperlayer];
            __AZ_activeLayer = nil;
        }
    } else if (__AZ_state == AZModifyingState && [self allowsModifyingOverlays]) {
        DLog(@"modifying");
        
        if (__AZ_activeLayer == nil) {
            CAShapeLayer *hitLayer = [self layerAtPoint:startPoint];
            if (hitLayer == __AZ_topLayer || [hitLayer valueForKey:@"AZOverlayObject"] == nil) {
                return;
            }
            __AZ_activeLayer = hitLayer;
            __AZ_activeCorner = [self cornerOfLayer:__AZ_activeLayer atPoint:startPoint];
            
            __AZ_xOffset = [__AZ_activeLayer position].x - endPoint.x;
            __AZ_yOffset = [__AZ_activeLayer position].y - endPoint.y;
            
            __AZ_activeOrigin = [__AZ_activeLayer frame].origin;
            __AZ_activeSize = [__AZ_activeLayer frame].size;
            
            DLog(@"xOffset: %f yOffset: %f", __AZ_xOffset, __AZ_yOffset);
        }
        [[NSCursor closedHandCursor] set];
        
        NSRect newRect = NSZeroRect;
        
        CGFloat xDelta = endPoint.x - startPoint.x;
        CGFloat yDelta = endPoint.y - startPoint.y;
        
        if (__AZ_activeCorner == AZNorthEastCorner) {
            newRect = NSMakeRect(__AZ_activeOrigin.x, 
                                 __AZ_activeOrigin.y, 
                                 __AZ_activeSize.width + xDelta, 
                                 __AZ_activeSize.height + yDelta);
        } else if (__AZ_activeCorner == AZNorthWestCorner) {
            newRect = NSMakeRect(__AZ_activeOrigin.x + xDelta, 
                                 __AZ_activeOrigin.y, 
                                 __AZ_activeSize.width - xDelta, 
                                 __AZ_activeSize.height + yDelta);
        } else if (__AZ_activeCorner == AZSouthEastCorner) {
            newRect = NSMakeRect(__AZ_activeOrigin.x, 
                                 __AZ_activeOrigin.y + yDelta, 
                                 __AZ_activeSize.width + xDelta, 
                                 __AZ_activeSize.height - yDelta);
        } else if (__AZ_activeCorner == AZSouthWestCorner) {
            newRect = NSMakeRect(__AZ_activeOrigin.x + xDelta, 
                                 __AZ_activeOrigin.y + yDelta, 
                                 __AZ_activeSize.width - xDelta, 
                                 __AZ_activeSize.height - yDelta);
        } else { //AZNoCorner
            newRect = NSMakeRect(endPoint.x + __AZ_xOffset - (__AZ_activeSize.width * 0.5f), 
                                 endPoint.y + __AZ_yOffset - (__AZ_activeSize.height * 0.5f), 
                                 __AZ_activeSize.width, 
                                 __AZ_activeSize.height);
        }
        
        /*
         TODO:
         for smoother operation, something like:
         
         do {
		 newrect = ...
		 
		 delta = delta - (delta/abs(delta)) // make delta 1 closer to zero each iteration
         } while (!isvalid);
         
         */
        
        DLog(@"corner: %lu : %@", __AZ_activeCorner, NSStringFromRect(newRect));
        
        BOOL validLocation = [self rect:newRect isValidForLayer:__AZ_activeLayer];
        
        if (validLocation) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.0f];
            [__AZ_activeLayer setFrame:newRect];
            CGPathRef path = [self newRectPathWithSize:newRect.size handles:YES];
            [__AZ_activeLayer setPath:path];
            CFRelease(path);
            [CATransaction commit];
        }
        
        if (done) {
            DLog(@"done modifying %@: %@", [__AZ_activeLayer valueForKey:@"AZOverlayObject"], NSStringFromRect([__AZ_activeLayer frame]));
            [__AZ_overlayDelegate overlayView:self didModifyOverlay:[__AZ_activeLayer valueForKey:@"AZOverlayObject"] newRect:[__AZ_activeLayer frame]];
            __AZ_activeLayer = nil;
            [[NSCursor openHandCursor] set];
        }
    }
}



#pragma mark Properties

- (id)overlayDataSource
{
    return __AZ_overlayDataSource;
}

- (void)setOverlayDataSource:(id)overlayDataSource
{
    __AZ_overlayDataSource = overlayDataSource;
    
    [self reloadData];
}

- (id)overlayDelegate
{
    return __AZ_overlayDelegate;
}

- (void)setOverlayDelegate:(id)overlayDelegate
{
    if (__AZ_overlayDelegate != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:__AZ_overlayDelegate
                                                        name:AZOverlayViewSelectionDidChangeNotification
                                                      object:self];
        [[NSNotificationCenter defaultCenter] removeObserver:__AZ_overlayDelegate
                                                        name:AZOverlayViewOverlayDidMoveNotification
                                                      object:self];
        [[NSNotificationCenter defaultCenter] removeObserver:__AZ_overlayDelegate
                                                        name:AZOverlayViewOverlayDidResizeNotification
                                                      object:self];
        [[NSNotificationCenter defaultCenter] removeObserver:__AZ_overlayDelegate
                                                        name:AZOverlayViewOverlayDidDeleteNotification
                                                      object:self];
    }
    
    __AZ_overlayDelegate = overlayDelegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:__AZ_overlayDelegate 
                                             selector:@selector(overlaySelectionDidChange:) 
                                                 name:AZOverlayViewSelectionDidChangeNotification 
                                               object:self];
	
    
    [self reloadData];
}

//@synthesize overlayFillColor = __AZ_overlayFillColor;

- (void)setOverlayFillColor:(CGColorRef)overlayFillColor
{
    CGColorRelease(__AZ_overlayFillColor);
    __AZ_overlayFillColor = overlayFillColor;
    CGColorRetain(__AZ_overlayFillColor);
}

- (CGColorRef)overlayFillColor
{
    return __AZ_overlayFillColor;
}

//@synthesize overlayBorderColor = __AZ_overlayBorderColor;

- (void)setOverlayBorderColor:(CGColorRef)overlayBorderColor
{
    CGColorRelease(__AZ_overlayBorderColor);
    __AZ_overlayBorderColor = overlayBorderColor;
    CGColorRetain(__AZ_overlayBorderColor);
}

- (CGColorRef)overlayBorderColor
{
    return __AZ_overlayBorderColor;
}

//@synthesize overlaySelectionFillColor = __AZ_overlaySelectionFillColor;

- (void)setOverlaySelectionFillColor:(CGColorRef)overlaySelectionFillColor
{
    CGColorRelease(__AZ_overlaySelectionFillColor);
    __AZ_overlaySelectionFillColor = overlaySelectionFillColor;
    CGColorRetain(__AZ_overlaySelectionFillColor);
}

- (CGColorRef)overlaySelectionFillColor
{
    return __AZ_overlaySelectionFillColor;
}

//@synthesize overlaySelectionBorderColor = __AZ_overlaySelectionBorderColor;

- (void)setOverlaySelectionBorderColor:(CGColorRef)overlaySelectionBorderColor
{
    CGColorRelease(__AZ_overlaySelectionBorderColor);
    __AZ_overlaySelectionBorderColor = overlaySelectionBorderColor;
    CGColorRetain(__AZ_overlaySelectionBorderColor);
}

- (CGColorRef)overlaySelectionBorderColor
{
    return __AZ_overlaySelectionBorderColor;
}


@synthesize overlayBorderWidth = __AZ_overlayBorderWidth;

@synthesize allowsCreatingOverlays = __AZ_allowsCreatingOverlays;
@synthesize allowsModifyingOverlays = __AZ_allowsModifyingOverlays;
@synthesize allowsDeletingOverlays = __AZ_allowsDeletingOverlays;
@synthesize allowsOverlappingOverlays = __AZ_allowsOverlappingOverlays;

@synthesize allowsOverlaySelection = __AZ_allowsOverlaySelection;
@synthesize allowsEmptyOverlaySelection = __AZ_allowsEmptyOverlaySelection;
@synthesize allowsMultipleOverlaySelection = __AZ_allowsMultipleOverlaySelection;

@synthesize target = __AZ_target;
@synthesize action = __AZ_action;
@synthesize doubleAction = __AZ_doubleAction;
@synthesize rightAction = __AZ_rightAction;
@synthesize clickedOverlay = __AZ_clickedOverlay;

@synthesize contents = __AZ_overlayCache;

@end

#pragma mark Notifications

NSString *AZOverlayViewSelectionDidChangeNotification = @"AZOverlayViewSelectionDidChangeNotification";
NSString *AZOverlayViewOverlayDidMoveNotification = @"AZOverlayViewOverlayDidMoveNotification";
NSString *AZOverlayViewOverlayDidResizeNotification = @"AZOverlayViewOverlayDidResizeNotification";
NSString *AZOverlayViewOverlayDidDeleteNotification = @"AZOverlayViewOverlayDidDeleteNotification";
