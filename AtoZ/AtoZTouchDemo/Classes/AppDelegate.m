//
//  AppDelegate.m
//  AtoZ
//
//  Created by Alex Gray on 2/17/15.
//  Copyright mrgray.com, inc. 2015. All rights reserved.
//

#import "RootViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;

@end



@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	RootViewController *rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
	window.rootViewController = navigationController;
	[window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *) application
{
	
}

- (void)applicationDidEnterBackground:(UIApplication *) application
{
	
}

- (void)applicationDidBecomeActive:(UIApplication *) application
{
		
}

- (void)dealloc 
{
	[window release];
	[super dealloc];
}


@end
