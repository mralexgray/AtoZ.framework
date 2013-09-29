
#import <PreferencePanes/PreferencePanes.h>

//@class ServiceManager;
@interface AtoZPrefs : NSPreferencePane

//@property (assign) IBOutlet   NSScrollView * serviceParent;
//@property (assign) IBOutlet 	    NSButton * homebrewScan;
//@property (readonly) 		   	 NSString * buildDate;
//@property (assign) IBOutlet ServiceManager * sm;

@property BOOL agentInstalled, agentRunning;
- (void)mainViewDidLoad;

@end
