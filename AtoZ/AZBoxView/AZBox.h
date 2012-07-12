//
//  AZBox.h
//  AtoZ
#import <Cocoa/Cocoa.h>
//#import <AppKit/AppKit.h>
//#import "AtoZ.h"
@interface AZBox : NSView

/*** The image that should be drawn at the center of the cell, or nil if you don't want a image to be drawn.  **/ 
//@property (nonatomic, retain) NSImage *image;
/*** The color of the selection ring.  **/
//@property (nonatomic, retain) NSColor *selectionColor;
/*** YES if the cell should draw an selection ring. You can set this to NO if you don't want to show a selection ring or if you provide your own.  The default is YES.**/
//@property (nonatomic, assign) BOOL drawSelection;
/*** YES if the cell is selected, otherwise NO.  **/
@property (nonatomic, assign) BOOL 	selected;
/*** YES if the mouse is hovering over cell, otherwise NO.  **/
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL 	hovered;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float inset;
@property (nonatomic, strong) id 	representedObject;
@property (nonatomic, readonly) NSString *cellIdentifier;
/*** Invoked when the cell is dequeued from a collection view. This will reset all settings to default.  **/
- (void)prepareForReuse;
/*** The designated initializer of the cell. Please don't use any other intializer!  **/
- (id)initWithReuseIdentifier:(NSString *)identifer;
- (id)initWithFrame:(NSRect)frame representing:(id)object atIndex:(NSUInteger)anIndex;
@end