
#import <Cocoa/Cocoa.h>

@interface NSViewController (NUExtensions)

/**
 
 \brief     Returns a view controller for the given nib.
 
 \details   There is an important restriction on the nib and controller.
            Both must be defined in the same nib file (thus "Colocated").
 
 */
+ (id) controllerWithColocatedNibNamed:(NSString*)nibName;

@end
