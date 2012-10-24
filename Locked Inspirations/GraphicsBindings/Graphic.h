/*
 
 File: Graphic.h
 
 Abstract: Defines the Graphic protocol.
 
 Version: 2.0
 

 */

#import <Foundation/Foundation.h>


extern NSString *GraphicDrawingBoundsKey;
extern NSString *GraphicDrawingContentsKey;

/*
 Graphic protocol to define methods all graphics objects must implement
 */

@protocol Graphic

@property CGFloat xLoc;
@property CGFloat yLoc;

+ (NSSet *)keysForValuesAffectingDrawingBounds;
+ (NSSet *)keysForValuesAffectingDrawingContents;
- (NSRect)drawingBounds;

-(void)drawInView:(NSView *)aView;
- (BOOL)hitTest:(NSPoint)point isSelected:(BOOL)isSelected;

@end
