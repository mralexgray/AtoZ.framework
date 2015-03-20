
@import        AtoZTouch ;
@Desc RootViewController : UITableViewController       @Stop
@Desc        AppDelegate : NSO <UIApplicationDelegate> @Stop
@Impl        AppDelegate { _Wind _window; }

- _IsIt_ application:_Appl_ app didFinishLaunchingWithOptions:_Dict_ lopts {

                        _window = INIT_(Wind,WithFrame:AZScreenFrame());
	RootViewController     * root = INIT_(RootViewController,WithStyle:UITableViewStylePlain);
	UINavigationController * navC = INIT_(UINavigationController,WithRootViewController:root);
	_window.rootViewController = navC;
	[_window makeKeyAndVisible];

  dispatch_async(dispatch_get_main_queue(), ^{

    NSLog(@"Hay %@ applications!\n", @(AZAppList.list.apps.allKeys.count));
    [root.tableView reloadData];

    AtoZTouchWelcome();
    NSLog(@"classes: %@", NSO.subclasses.joinedByNewlines);
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

