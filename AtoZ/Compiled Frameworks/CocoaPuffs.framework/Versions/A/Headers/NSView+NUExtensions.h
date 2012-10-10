
#import <Cocoa/Cocoa.h>

@interface NSView (NUExtensions)

- (void) recursivelyDisableAutorisizingMaskConstraints;

- (NSImage*) bitmapImageForRect:(NSRect)rect;
- (NSImage*) bitmapImageForVisibleRect;
- (NSImage*) bitmapImage;


- (NSPoint) convertPointToScreen:(NSPoint)point;
- (NSPoint) convertPoint:(NSPoint)point fromNestedLayer:(CALayer*)layer;
- (NSRect) convertRect:(NSRect)rect fromNestedLayer:(CALayer*)layer;

@end
