/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <AppKit/AppKit.h>

@interface NBBModule : NSWindowController
@property(nonatomic, copy) NSString* identifier;
@property(nonatomic, readonly) IBOutlet NSView* preferenceView;
@property(nonatomic, readonly) NSImage* moduleIcon;

// sleep notifications
- (void)systemWillSleep:(NSNotification*) notification;
- (void)systemDidWakeFromSleep:(NSNotification*) notification;
@end
