
#import <SecurityFoundation/SFAuthorization.h>
#import <ServiceManagement/ServiceManagement.h>
#import <PreferencePanes/PreferencePanes.h>
#import <AtoZ/AtoZ.h>

@interface AtoZPrefs : NSPreferencePane

@property BOOL agentInstalled, agentRunning, hotkeyEnabled;
@property NSDate * agentStartDate;
@property (readonly) NSURL * agentURL;

- (IBAction) showReadme: (id) sender;

@property (ASS) IBOutlet  MASShortcutView *shortcut;
@property IBOutlet BGHUDProgressIndicator *indicator;

//@property NSTreeController *snippets;
//@property (assign) IBOutlet   NSScrollView * serviceParent;
//@property (assign) IBOutlet 	    NSButton * homebrewScan;
//@property (readonly) 		   	 NSString * buildDate;
//@property (assign) IBOutlet ServiceManager * sm;

@end


