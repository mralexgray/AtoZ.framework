//
//  NSOutlineView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 3/27/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSOutlineView (AtoZ)

@end



@interface NSTreeNode (ESExtensions)
- (NSA*)descendants;
- (NSA*)groupDescendants;
- (NSA*)leafDescendants;
- (NSA*)siblings;
- (BOOL)isDescendantOfNode:(NSTreeNode *)node;
- (BOOL)isSiblingOfNode:(NSTreeNode *)node;
- (BOOL)isSiblingOfOrDescendantOfNode:(NSTreeNode *)node;
- (NSIndexPath *)adjacentIndexPath;
- (NSIndexPath *)nextSiblingIndexPath;
- (NSIndexPath *)nextChildIndexPath;
@end




@interface NSTreeController (ESExtensions)
- (NSIndexPath *)indexPathForInsertion;
- (void)selectNone;
- (NSA*)rootNodes;
- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
- (NSA*)flattenedContent;
- (NSA*)flattenedNodes;
- (NSTreeNode *)nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath;
- (NSTreeNode *)nextSiblingOfNode:(NSTreeNode *)node;
- (void)selectParentFromSelection;
@end
