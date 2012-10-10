
#import <Cocoa/Cocoa.h>

@class NUPropertyInspectorView;

@interface NUPropertySheetView : NSView

- (id) initWithName:(NSString*)aName andLabel:(NSString*)aLabel;
+ (id) propertySheetWithName:(NSString*)aName andLabel:(NSString*)aLabel;

@property (copy) NSString *name;
@property (copy) NSString *label;
@property (copy) NSArray  *inspectorViews;
@property (assign) BOOL inspectorsVisible;

- (void) addInspectorView:(NUPropertyInspectorView*)inspectorView;
- (void) removeInspectorView:(NUPropertyInspectorView*)inspectorView;

@end
