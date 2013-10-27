//
//  UAGitUtilities.h
//  UAGithubEngine
//
//  Created by Alex Gray on 10/26/13.
//
//

#import <Foundation/Foundation.h>

@interface UAGitUtilities : NSObject

+ (NSString*) lookupUsername;
+ (NSString*) commandLineCallWithPath:(NSString*)path andArgs:(NSArray*)args;
+ (NSString*) gitPath;
@end
