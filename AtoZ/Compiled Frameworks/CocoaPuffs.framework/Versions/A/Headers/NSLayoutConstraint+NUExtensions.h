
#import <Cocoa/Cocoa.h>

@interface NSLayoutConstraint (NUExtensions)

+ (NSArray*) constraintsWithItem:(NSView*)aView havingWidth:(double)width;
+ (NSArray*) constraintsWithItem:(NSView*)aView havingHeight:(double)height;

+ (NSArray*) constraintsWithItem:(NSView*)aView havingMinimumWidth:(double)minWidth;
+ (NSArray*) constraintsWithItem:(NSView*)aView havingMinimumHeight:(double)minHeight;
+ (NSArray*) constraintsWithItem:(NSView*)aView spanningWidthOfSuperviewWithPadding:(double)padding;


+ (NSArray*) constraintsWithItemsHavingEqualWidth:(NSArray*)items;
+ (NSArray*) constraintsWithItemsHavingEqualLeftEdges:(NSArray*)items;
+ (NSArray*) constraintsWithItemsHavingEqualRightEdges:(NSArray*)items;
+ (NSArray*) constraintsWithItems:(NSArray*)items eachSpanningWidthOfSuperviewWithPadding:(double)padding;

+ (NSArray*) constraintsWithItemsEachAlignedWithBaselineOfSuperview:(NSArray*)items;
+ (NSArray*) constraintsWithItemsEachAlignedWithCenterYOfSuperview:(NSArray*)items;



+ (NSArray*) constraintsWithVisualFormats:(NSArray*)formats
                                  options:(NSLayoutFormatOptions)opts
                                  metrics:(NSDictionary *)metrics
                                    views:(NSDictionary *)views
;



+ (NSArray*) constraintsForStackedItems:(NSArray*)items
                         withTopPadding:(NSString*)topPad
                             itemHeight:(NSString*)height
                                spacing:(NSString*)spacing
                          bottomPadding:(NSString*)bottomPad
;


@end
