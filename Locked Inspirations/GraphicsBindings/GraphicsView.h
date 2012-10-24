/*
 
 File: GraphicsView.h
 
 Abstract: View that displays a collection of graphic objects.
 
 Version: 2.0
 

 */

#import <Cocoa/Cocoa.h>

@class Circle;

@interface GraphicsView : NSView


@property (nonatomic, copy) NSArray *oldGraphics;
@property (nonatomic, retain) NSMutableDictionary *bindingInfo;

//@property (copy) NSArray *oldGraphics;

- (void)startObservingGraphics:(NSArray *)graphics;
- (void)stopObservingGraphics:(NSArray *)graphics;

// bindings-related -- infoForBinding and convenience methods

- (NSDictionary *)infoForBinding:(NSString *)bindingName;

@property (readonly) id graphicsContainer;
@property (readonly) NSString *graphicsKeyPath;
@property (readonly) id selectionIndexesContainer;
@property (readonly) NSString *selectionIndexesKeyPath;
@property (readonly) NSArray *graphics;
@property (readonly) NSIndexSet *selectionIndexes;

@end

