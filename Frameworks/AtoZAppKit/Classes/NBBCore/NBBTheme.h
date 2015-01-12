/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <AppKit/AppKit.h>

#import "NBBThemable.h"

@interface NBBTheme : NSObject
@property(nonatomic, copy) NSString* identifier;
@property(nonatomic, retain) NSMutableDictionary* prefrences;

// generic theme methods
- (NSFont*)smallFont;
- (NSFont*)normalFont;
- (NSFont*)largeFont;

- (NSColor*)textColor;

- (NSColor*)cellForegroundColor;
- (NSColor*)labelForegroundColor;

- (NSColor*)cellBackgroundColor;
- (NSColor*)labelBackgroundColor;

- (NSColor*)highlightColor;

// combination for font, color and alignment
- (NSDictionary*)cellTextAttributes;
- (NSDictionary*)labelTextAttributes;

- (NSColor*)windowBackgroundColor;

- (CAAnimation*)windowInAnimation;
- (CAAnimation*)windowOutAnimation;

// subclasses can implement special logic for specific UI elements.
// default implementation simply calls the other color functions based on object class
- (NSColor*)foregroundColorForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object;
- (NSColor*)backgroundColorForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object;
- (NSColor*)borderColorForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object;

- (CGFloat)borderWidthForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object;
// default implementation returns view's frame 
- (NSRect)frameForObject:(NSView*) view;

// default theme preferences should supply the frames for controls
// if the theme wishes controls to have a layout diffrent from NIB
// you can also override any application default preference
- (NSDictionary*)defaultThemePrefrences;
@end
