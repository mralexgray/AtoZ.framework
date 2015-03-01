

#import <UIKit/UIKit.h>

#ifndef AtoZ_AZTMacroDefines_h
#define AtoZ_AZTMacroDefines_h


#pragma mark -  DATASOURCE


#define TVMethod(RET_TYPE)   \
      - (RET_TYPE) tableView:(UITableView*)tv

#define TVNumRowsInSection    \
        TVMethod(NSInteger) numberOfRowsInSection:(NSInteger)section

#define TVNumSections         \
      - (NSInteger) numberOfSectionsInTableView:(UITableView*)tv

#define TVCellForRowAtIP  \
        TVMethod(UITableViewCell*) cellForRowAtIndexPath:(NSIndexPath *)ip


#pragma mark -  DELEGATE


#define TVHeightForRowAtIP \
        TVMethod(CGFloat) heightForRowAtIndexPath:(NSIndexPath*)ip

#define TVDidSelectRowAtIP \
        TVMethod(void) didSelectRowAtIndexPath:(NSIndexPath*)ip



#define AZiMAIN(DELEGATE) \
\
int main(int argc, char **argv) {	int ret;	@autoreleasepool { \
\
  ret = UIApplicationMain(argc, argv, @#DELEGATE, @#DELEGATE); \
\
} return ret; }


#pragma mark - Relocate to universal

#if TARGET_OS_IPHONE
  #define NSColor UIColor
  #define NSC NSColor
#else

#endif

















#endif