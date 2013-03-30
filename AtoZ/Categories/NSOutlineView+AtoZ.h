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
- (NSArray *)descendants;
- (NSArray *)groupDescendants;
- (NSArray *)leafDescendants;
- (NSArray *)siblings;
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
- (NSArray *)rootNodes;
- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)flattenedContent;
- (NSArray *)flattenedNodes;
- (NSTreeNode *)nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath;
- (NSTreeNode *)nextSiblingOfNode:(NSTreeNode *)node;
- (void)selectParentFromSelection;
@end
