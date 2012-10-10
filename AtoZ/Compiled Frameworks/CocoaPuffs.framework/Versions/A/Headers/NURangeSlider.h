
#import <AppKit/AppKit.h>

@interface NURangeSlider : NSView

@property (assign,nonatomic) double absoluteMinimum;
@property (assign,nonatomic) double absoluteMaximum;
@property (assign,nonatomic) double rangeMinimum;
@property (assign,nonatomic) double rangeMaximum;
@property (assign,nonatomic) double rounding;
@property (assign,nonatomic) BOOL   tracksKnobVisibility;

@end
