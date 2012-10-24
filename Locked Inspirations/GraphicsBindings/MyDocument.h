/*
 
 File: MyDocument.h
 
 Abstract: Class that represents a document.
 
 Version: 2.0
 

 */


#import <Cocoa/Cocoa.h>

@class GraphicsView;
@class JoystickView;


@interface MyDocument : NSDocument

@property (assign)	IBOutlet JoystickView *shadowInspector;
@property (assign)	IBOutlet GraphicsView *graphicsView;
	
@property (assign)	IBOutlet NSArrayController *graphicsController;

@property (nonatomic, copy) 	NSMutableArray *graphics;

- (unsigned int)countOfGraphics;
- (id)objectInGraphicsAtIndex:(unsigned int)index;
- (void)insertObject:(id)anObject inGraphicsAtIndex:(unsigned int)index;
- (void)removeObjectFromGraphicsAtIndex:(unsigned int)index;
- (void)replaceObjectInGraphicsAtIndex:(unsigned int)index withObject:(id)anObject;

@end

