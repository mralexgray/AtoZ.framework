//
//  SDPrefPanel.h
//  Chatter
//
//  Created by Steven on 12/5/08.
//  Copyright 2008 Giant Robot Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (SDResizableWindow)

- (void) setContentViewSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate;

- (NSRect) windowFrameForNewContentViewSize:(NSSize)newSize;

@end
