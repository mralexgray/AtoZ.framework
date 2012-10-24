/*
 
 File: JoystickView.h
 
 Abstract: View that represents a joystick allowing angle and offset to be manipulated graphically.
 
 This class may be used with garbage collection or in a managed memory environment.
 
 Version: 2.0
 
 
 */

#import <Cocoa/Cocoa.h>

@interface JoystickView : NSView



// expect angle in degrees
//@property (nonatomic, assign) float angle, offset, maxOffset;
@property (nonatomic, assign) BOOL badSelectionForAngle,
badSelectionForOffset,
multipleSelectionForAngle,
multipleSelectionForOffset;

@property (nonatomic, retain) NSMutableDictionary *bindingInfo;
@property (nonatomic, assign) BOOL mouseDown;
@property (nonatomic, assign) CGFloat angle, offset, maxOffset;


// bindings settings and options

- (NSDictionary *)infoForBinding:(NSString *)bindingName;

@property (readonly, nonatomic) id observedObjectForAngle;
@property (readonly, nonatomic) NSString *observedKeyPathForAngle;

@property (readonly, nonatomic) id observedObjectForOffset;
@property (readonly, nonatomic) NSString *observedKeyPathForOffset;

@property (readonly, nonatomic) NSString *angleValueTransformerName;

@property (readonly, nonatomic) BOOL allowsMultipleSelectionForAngle;
@property (readonly, nonatomic) BOOL allowsMultipleSelectionForOffset;

@end

