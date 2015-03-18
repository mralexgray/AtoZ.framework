
@import             AtoZTouch ;
@interface RootViewController : UITableViewController             @end
@interface        AppDelegate : NSObject <UIApplicationDelegate>; @end

@implementation AppDelegate { UIWindow *_window; }

- _IsIt_ application:_Appl_ app didFinishLaunchingWithOptions:_Dict_ lopts {

	_window = [Wind.alloc initWithFrame:UIScreen.mainScreen.bounds];
	RootViewController *rootViewController = [RootViewController.alloc initWithStyle:UITableViewStylePlain];
	UINavigationController *navigationController = [UINavigationController.alloc initWithRootViewController:rootViewController];
	_window.rootViewController = navigationController;
	[_window makeKeyAndVisible];

  dispatch_async(dispatch_get_main_queue(), ^{

    fprintf(stderr,"Hay %lu applications!\n", _ULng_ AZApplicationList.sharedApplicationList.applications.allKeys.count);
    [rootViewController.tableView reloadData];

    AtoZTouchWelcome();
    fprintf(stderr,"classes: %s", NSO.subclasses.joinedByNewlines.UTF8String);
  });

	return YES;
}
@end

@implementation RootViewController

- initWithStyle:(UITableViewStyle)s { return self = [super initWithStyle:s] ? self : nil; }

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toOrient {

  return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ?:
                                          toOrient == UIInterfaceOrientationPortrait;
}

TVNumSections       { return 1; }
TVNumRowsInSection  { return 0; }
TVCellForRowAtIP    {

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier] ?:
                          [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	// Configure the cell.
	return cell;
}
@end

MAIN( return UIApplicationMain(argc, argv, nil, @"AppDelegate"); )

