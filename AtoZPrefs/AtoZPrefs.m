
#import "AtoZPrefs.h"
#import "ServiceManager.h"

@implementation AtoZPrefs

//- (void)mainViewDidLoad
//{
//	 self.sm = [ServiceManager.alloc initWithBundle:self.bundle andView:self.serviceParent];
//    [_sm cleanServicesFile];
//    self.homebrewScan.target = _sm;
//    self.homebrewScan.action = @selector(handleHomebrewScanClick:);
//    [_sm renderList];
//}

- (NSString*) buildDate { return  [NSBundle bundleForClass:self.class].infoDictionary[@"PROJ_BUILD_DATE"]?:@""; }

@end
