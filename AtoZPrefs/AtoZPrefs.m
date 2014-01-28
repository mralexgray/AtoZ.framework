
#import "AtoZPrefs.h"


@implementation AtoZPrefs

- (NSURL*) agentURL {  return [self.bundle URLForAuxiliaryExecutable:@""agentName]; }

- (BOOL) installAgent:(NSError**)e	{ 	NSURL* libraryUrl, *agentExcutableUrl, *appSupportUrl;

	NSBundle    * bundle = self.bundle;
	NSURL    * bundleUrl = bundle.bundleURL;
	NSURL * prefPanesUrl = URLFORDOMAIN(NSPreferencePanesDirectory);

  if(!prefPanesUrl) return NO;
	if(![bundleUrl.absoluteString hasPrefix: prefPanesUrl.absoluteString])
		return NO_AssignError(e, NewError(@"This preference pane must be installed for each user individually. "
															"Installation for all users is currently not supported. Remove this preference pane "
															"and then reinstall it, this time for the current user only."));
/*  Prepare hard link outside the bundle pointing to agent inside the bundle.
    The hardlink will create prevent the agent from becoming inaccessible if the preference pane is deleted, 
    enabling the agent to self-destruct itself in that case.    
*/
	if(!self.agentURL) return NO_AssignError(e, NewError( @"Can't find agent executable"));

  if(!(appSupportUrl = URLFORDOMAIN(NSApplicationSupportDirectory))) return NO;
	
	NSURL* agentAppSupportUrl = [appSupportUrl URLByAppendingPathComponent:agentLabel isDirectory:YES];
	NSURL* agentExecutableLinkUrl = [agentAppSupportUrl URLByAppendingPathComponent:@""agentName];
	if(![fm createDirectoryAtURL: agentAppSupportUrl withIntermediateDirectories:YES attributes:nil error:e]) return NO;

	if ([fm fileExistsAtPath:agentExecutableLinkUrl.path]     &&
     ![fm  removeItemAtURL:agentExecutableLinkUrl error:e]  ||
     ![fm linkItemAtURL:agentExcutableUrl toURL:agentExecutableLinkUrl error:e]) return NO;

	/** Read current agent configuration, if possible. */

	if(!(libraryUrl = URLFORDOMAIN(NSLibraryDirectory))) return NO;

	NSURL    * agentConfsUrl = [libraryUrl URLByAppendingPathComponent: @"LaunchAgents" isDirectory: YES];
	NSString * agentConfName = [agentLabel stringByAppendingString: @".plist"];
	NSURL     * agentConfUrl = [agentConfsUrl URLByAppendingPathComponent:agentConfName];
	
	NSDictionary * curAgentConf = nil;
	if([fm fileExistsAtPath:agentConfUrl.path isDirectory: NO])
    curAgentConf = [NSDictionary dictionaryWithContentsOfURL:agentConfUrl];
	/*
	 * Prepare new agent configuration
	 */
	NSURL * agentConfTemplateUrl = [bundle.sharedSupportURL URLByAppendingPathComponent: agentConfName];
	NSMutableDictionary * newAgentConf = [NSMutableDictionary dictionaryWithContentsOfURL:agentConfTemplateUrl];
	if( newAgentConf == nil )
		return NO_AssignError( e, NewError( @"Can't load job description template" ) );
	newAgentConf[@"ProgramArguments"]  = @[agentExecutableLinkUrl.path];
	newAgentConf[@"WatchPaths"]        = @[bundleUrl.path, @"/z".stringByResolvingSymlinksAndAliases];// [Environment savedEnvironmentPath]];
	/** If new agent configuration is different to currently installed one, ... */
	NSTask* task;
	if( ![newAgentConf isEqualToDictionary: curAgentConf] ) { 		/** ... install and load it into launchd. */
		if( curAgentConf )
			[task = [NSTask launchedTaskWithLaunchPath:launchctlPath arguments: @[ @"unload", agentConfUrl.path ]] waitUntilExit];

    [fm createDirectoryAtPath:agentConfUrl.path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:e];
		if(![newAgentConf  writeToFile:agentConfUrl.path atomically:YES])
    // createParent: YES createAncestors: NO error:e] )
			return NO_AssignError( e, NewError( @"Failed to write agent's launchd job description." ) );

		task = [NSTask launchedTaskWithLaunchPath: launchctlPath
												  arguments: @[ @"load", agentConfUrl.path ]];
	} else 	/** ... otherwise start agent.	 */
		task = [NSTask launchedTaskWithLaunchPath: launchctlPath
												  arguments: @[ @"start", agentLabel ]];
	[task waitUntilExit];
	if( task.terminationStatus != 0 ) {
		return NO_AssignError(e, NewError( @"Failed to load/start agent" ) );
	}
	self.agentStartDate = NSDate.date;
	self.agentURL = agentExcutableUrl.copy;
	return self.agentInstalled = YES;
}

- (IBAction) showReadme: (id) sender		{ NSBeep();
//	[[AboutSheetController sheetControllerWithBundle: self.bundle] loadView];
}
 /**
   END AVPANE
  */

- (void)mainViewDidLoad	{  NSError* error = nil;

	if(![self installAgent:&error] ) { [AZSHAREDAPP presentError:error]; LogError(error); }

  [_indicator startAnimation:nil];
  [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"AtoZShortcutKey" handler:^{
		id bezelServicesTask = [NSConnection rootProxyForConnectionWithRegisteredName:@"com.apple.BezelServices" host:nil];
		[bezelServicesTask performSelectorWithoutWarnings:NSSelectorFromString(@"launchSystemPreferences:") withObject:@"Security.prefPane"];
	}];

	[AZTalker say:@"Beinvenidos a AtoZ framework"];

	NSRect rect         = self.mainView.frame;
	NSWindow *prefsWin  = AZAPPWINDOW;
	rect.size.width = [prefsWin contentRectForFrameRect:prefsWin.frame].size.width;
	[self.mainView setFrame:rect];
}

- (NSString*) buildDate { return  [NSBundle bundleForClass:self.class].infoDictionary[@"PROJ_BUILD_DATE"]?:@""; }

@end

//	self.sm = [ServiceManager.alloc initWithBundle:self.bundle andView:self.serviceParent];
//    [_sm cleanServicesFile];
//    self.homebrewScan.target = _sm;
//    self.homebrewScan.action = @selector(handleHomebrewScanClick:);
//    [_sm renderList];

/*
- (void) didSelect        { self.applyChangesTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target: self
																								  		  selector: @selector( timerTarget: ) 
																										  userInfo: NULL repeats: YES];
}
- (void) didUnselect			{	[self applyChanges]; [_applyChangesTimer invalidate];	}
- (void) applyChanges			{
	
	Environment* environment = [Environment withArrayOfEntries: self.editableEnvironment];
	if( ![environment isEqualToEnvironment: _savedEnvironment] ) { self.agentInstalled = NO;
		NSError* error = nil;
		if( [environment savePlist: &error] ) _savedEnvironment = environment;
		else {
			LogError( error );
			self.editableEnvironment = [_savedEnvironment toArrayOfEntries];       // revert
			[self presentError: error ];
		}
	}
	if (!_agentInstalled) self.agentInstalled = YES;
}
*/
