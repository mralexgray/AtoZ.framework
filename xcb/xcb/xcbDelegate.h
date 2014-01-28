


@class Project, NotifyingOperationQueue, DefinitionController;

@interface xcbDelegate : NSObject <NSApplicationDelegate>

@property      	MenuAppController *menuApp;
@property      DefinitionController *defCTL;
@property   NotifyingOperationQueue *buildQueue;
@property  			   NSMutableArray *archive;
@property                      BOOL launchedWithDocument, 
														  launching;
- (IBAction) open: (id) aSender;

@end


/*

-  (void) dropService: (NSPasteboard*) aPasteBoard											// Services
				userData: 			  (NSS*) aUserData
					error:          (NSS**) anError							{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSArray* aTypes = [aPasteBoard types];
	id aData = nil;
	if ([aTypes containsObject: NSFilenamesPboardType] &&
		(aData = [aPasteBoard propertyListForType: NSFilenamesPboardType]))		[self runScriptWithArguments: aData];
	else	 {		*anError = @"Unknown data type in pasteboard.";		NSLog(@"Service invoked with no valid pasteboard data.");	 }
}

*/
