//
//  NotificationCenterSpy.h
// 
//  Created by Javier Soto on 9/13/11.
//
//  Description:
//  Allows you to see all notifications being posted by the Cocoa frameworks and by yourself before they get delivered.
//
//  Usage:
//  #import NotificationCenterSpy.h
//  [NSNotificationCenterSpy toggleSpyingAllNotifications] to enable NSLogging all notifications being posted.
//  Call the method again to disable

#import <Foundation/Foundation.h>
#define AZNOTCENTERSPYTOGGLE [NotificationCenterSpy toggleSpyingAllNotifications]

@interface NotificationCenterSpy : NSObject

+ (void)toggleSpyingAllNotifications;

+ (void)toggleSpyingAllNotificationsIgnoring:(NSA*)notes ignoreOverlyVerbose:(BOOL)ignore;

@end
