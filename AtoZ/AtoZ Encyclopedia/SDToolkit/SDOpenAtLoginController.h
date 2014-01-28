//
// Created 2008 by Steven Degutis
// http://www.thoughtfultree.com/
// Some rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDOpenAtLoginController : NSObject {
	LSSharedFileListRef sharedFileList;
}

@property BOOL opensAtLogin;

@end
