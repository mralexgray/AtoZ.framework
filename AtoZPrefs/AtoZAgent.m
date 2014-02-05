
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <asl.h>
#include "launch.h"
#import <Foundation/Foundation.h>
//#import "Environment.h"
//#import "Constants.h"

static NSError *__autoreleasing*e = nil;

int main( int argc, const char** argv )	{ 	NSLog( @"Started agent %s (%u)", argv[0], getpid() );

	NSURL* libraryUrl;
  /* Read current agent configuration.*/
  if(!(libraryUrl = URLFORDOMAIN(NSLibraryDirectory)))
    return NSLog( @"Can't find current user's library directory: %@", e), 1;

	NSURL * agentConfsUrl = [libraryUrl    URLByAppendingPathComponent: @"LaunchAgents" isDirectory: YES];
	NSS   * agentConfName = [agentLabel                     withString:@".plist"];
	NSURL *  agentConfUrl = [agentConfsUrl URLByAppendingPathComponent: agentConfName];
	NSD   *  curAgentConf = [NSD           dictionaryWithContentsOfURL: agentConfUrl];
	/** As per convention, the path to the preference pane is the first entry in
	 * WatchPaths. Normally, the preference pane bundle still exists and we
	 * simply export the environment. Otherwise, we uninstall the agent by
	 * removing the files created outside the bundle during installation. */
	NSString* envPanePath = [curAgentConf objectForKey: @"WatchPaths"][0];		BOOL isDir;
	if( [NSFileManager.defaultManager fileExistsAtPath: envPanePath isDirectory: &isDir] && isDir ) {
    NSLog( @"Setting environment" );
//    Environment* environment = [Environment loadPlist]; [environment export];

	} else {	NSLog( @"Uninstalling agent" );
		/** Remove agent binary */
		NSString* agentExecutablePath = [curAgentConf objectForKey: @"ProgramArguments"][0];
		if( ![fm removeItemAtPath:agentExecutablePath error:e])
			NSLog( @"Failed to remove agent executable (%@): %@", agentExecutablePath,e);
		/** Remove agent plist ...	 */
		if( ![fm removeItemAtURL: agentConfUrl error:e] )
			NSLog( @"Failed to remove agent configuration (%@): %@", agentConfUrl,e );
		/** ... and its parent directory. */
		NSString* envAgentAppSupport = agentExecutablePath.stringByDeletingLastPathComponent;
		if( ![fm removeItemAtPath:envAgentAppSupport error:e] )
			NSLog( @"Failed to remove agent configuration (%@): %@", agentConfUrl,e);
		/** Remove the job from launchd. This seems to have the same effect as
		 * 'unload' except it doesn't cause the running instance of the agent to
		 * be terminated and it works without the presence of agent executable or plist. */
		NSTask* task = [NSTask launchedTaskWithLaunchPath:launchctlPath arguments:@[@"remove",agentLabel]];
		[task waitUntilExit];
		if(!task.terminationStatus) NSLog( @"Failed to unload agent (%@)", agentLabel);
	}
	[NSUserDefaults.standardUserDefaults setPersistentDomain:@{@"lastRun":NSDate.date} forName:@"net.hannesschmidt.EnvAgent"];
	NSLog( @"Exiting agent %s (%u)", argv[0], getpid() );
	return 0;
}
