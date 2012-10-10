
#import <Cocoa/Cocoa.h>

@interface NUPropertyInspectorView : NSView

- (id) initWithName:(NSString*)aName label:(NSString*)aLabel andControl:(NSControl*)aControl;
+ (id) propertyInspectorWithName:(NSString*)aName label:(NSString*)aLabel andControl:(NSControl*)aControl;

@property (copy) NSString *name;
@property (copy) NSString *label;
@property (copy) NSString *units;
@property (assign) BOOL resizableControl;

@property (readonly) NSTextField *labelField;
@property (readonly) NSControl   *valueControl;
@property (retain)   NSTextField *textField;
@property (readonly) NSTextField *unitsField;

@end
