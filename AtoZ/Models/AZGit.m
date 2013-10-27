//
//  UAGitUtilities.m
//  UAGithubEngine
//
//  Created by Alex Gray on 10/26/13.
//
//

#import "UAGitUtilities.h"

@implementation UAGitUtilities

+ (NSString*) lookupUsername {  //try to get the github username

		NSString *gitname = [self commandLineCallWithPath:self.gitPath andArgs:@[@"config", @"--global", @"github.user"]];
    if(gitname && gitname.length) return gitname;
    //try to get the git username
    NSString *username = [self commandLineCallWithPath:self.gitPath andArgs:@[@"config", @"--global", @"user.name"]];
    if(username && username.length) return username;
    return nil;
}
+ (NSString *)commandLineCallWithPath:(NSString*)path andArgs:(NSArray *)args{

    NSTask *task								= NSTask.new;
    task.currentDirectoryPath		= @"/tmp";
    task.environment						= NSProcessInfo.processInfo.environment;
    task.launchPath							= path;
    task.arguments							= args;
    NSPipe *filePipe						= NSPipe.pipe;
    task.standardOutput					= filePipe;
    task.standardError					= filePipe;
    NSFileHandle *file					= filePipe.fileHandleForReading;  task.launch;
    NSData *data								= file.readDataToEndOfFile;				task.waitUntilExit;  file.closeFile;
    return [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSArray *)searchLocations{
	return @[@"/opt/local/bin/git", @"/usr/bin/git", @"/sw/bin/git", @"/opt/git/bin/git", @"/usr/local/bin/git", @"/usr/local/git/bin/git", @"~/bin/git".stringByExpandingTildeInPath];
}

+ (NSString*) gitPath{    //try the enviorment variable
    char *path = getenv("GIT_PATH");  if(path) return [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
    for(NSString *location in self.searchLocations) if([NSFileManager.defaultManager fileExistsAtPath:location]) return location;
    return nil;
		//try which
    //NSString *whichPath = [Git commandLineCallWithPath:@"/usr/bin/which" andArgs:[NSArray arrayWithObjects:@"git",nil]];
    //if(whichPath && ![whichPath isEqualToString:@""]){ return whichPath; }
    //try seach location;
}

@end
