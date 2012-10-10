
#import <Foundation/Foundation.h>

@interface NUBoolToNSColorValueTransformer : NSValueTransformer

@property (retain) NSColor *yesColor;
@property (retain) NSColor *noColor;

/// Designated initializer
- (id) initWithYesColor:(NSColor*)yColor andNoColor:(NSColor*)nColor;

@end
