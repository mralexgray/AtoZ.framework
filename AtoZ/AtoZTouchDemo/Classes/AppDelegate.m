//
//  AppDelegate.m
//  AtoZ
//
//  Created by Alex Gray on 2/17/15.
//  Copyright mrgray.com, inc. 2015. All rights reserved.
//

#import "RootViewController.h"
@import AtoZTouch;


@interface AppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic) UIWindow *window;

@end



@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{

  AtoZTouchWelcome();
  printf("Hay %lu applications!\n", AZApplicationList.sharedApplicationList.applications.allKeys.count);

	window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
	RootViewController *rootViewController = [RootViewController.alloc initWithStyle:UITableViewStylePlain];
	UINavigationController *navigationController = [UINavigationController.alloc initWithRootViewController:rootViewController];
	window.rootViewController = navigationController;
	[window makeKeyAndVisible];
	return YES;
}


@end

int main(int argc, char *argv[]) { 

  return UIApplicationMain(argc, argv, nil, @"AppDelegate");
}
