//
//  NSOutlineView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 3/27/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "NSOutlineView+AtoZ.h"

@implementation NSOutlineView (AtoZ)

@end


//  NSTreeNode_Extensions.m
//  SortedTree
//  Created by Jonathan Dann on 14/05/2008.
//
//#import "NSTreeNode_Extensions.h"
//#import "NSIndexPath_Extensions.h"

@implementation NSTreeNode (ESExtensions)

// returns an array of NSTreeNodes descending from self
- (NSArray *)descendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *child in [self childNodes]) {
		[array addObject:child];
		if (![child isLeaf])
			[array addObjectsFromArray:[child descendants]];
	}
	return [[array copy] autorelease];
}

- (NSArray *)groupDescendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *item in [self childNodes]) {
		if (![item isLeaf])	{
			[array addObject:item];
			[array addObjectsFromArray:[item groupDescendants]];
		}
	}
	return [[array copy] autorelease];
}

- (NSArray *)leafDescendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *item in [self childNodes]) {
		if ([item isLeaf])
			[array addObject:item];
		else
			[array addObjectsFromArray:[item leafDescendants]];
	}
	return [[array copy] autorelease];
}

// all the siblings, including self
- (NSArray *)siblings;
{
	return [[self parentNode] childNodes];
}

- (BOOL)isDescendantOfNode:(NSTreeNode *)node;
{
	return [[node descendants] containsObject:self];
}

- (BOOL)isSiblingOfNode:(NSTreeNode *)node;
{
	return ([self parentNode] == [node parentNode]);
}

- (BOOL)isSiblingOfOrDescendantOfNode:(NSTreeNode *)node;
{
	return ([self isSiblingOfNode:node] || [self isDescendantOfNode:node]);
}

// the next increasing index path
-(NSIndexPath *)adjacentIndexPath;
{
	return [[self indexPath] indexPathByIncrementingLastIndex];
}

// the next 'free' index path at the end of the children array of self's parent
- (NSIndexPath *)nextSiblingIndexPath;
{
	return [[[self parentNode] indexPath] indexPathByAddingIndex:[[[self parentNode] childNodes] count]];
}

- (NSIndexPath *)nextChildIndexPath;
{
	if ([self isLeaf])
		return [self nextSiblingIndexPath];
	return [[self indexPath] indexPathByAddingIndex:[[self childNodes] count]];
}
@end


@implementation NSTreeController (ESExtensions)
// will create an NSIndexPath after the selection, or as for the top of the children of a group node
- (NSIndexPath *)indexPathForInsertion;
{
	NSUInteger rootTreeNodesCount = [[self rootNodes] count];
	NSArray *selectedNodes = [self selectedNodes];
	NSTreeNode *selectedNode = [selectedNodes firstObject];
	NSIndexPath *indexPath;
	
	if ([selectedNodes count] == 0)
		indexPath = [NSIndexPath indexPathWithIndex:rootTreeNodesCount];
	else if ([selectedNodes count] == 1) {
		if (![selectedNode isLeaf])
			indexPath = [[selectedNode indexPath] indexPathByAddingIndex:0];
		else {
			if ([selectedNode parentNode])
				indexPath = [selectedNode adjacentIndexPath];
			else
				indexPath = [NSIndexPath indexPathWithIndex:rootTreeNodesCount];
		}
	} else
		indexPath = [[selectedNodes lastObject] adjacentIndexPath];
	return indexPath;
}

// makes a blank selection in the outline view
- (void)selectNone;
{
	[self removeSelectionIndexPaths:[self selectionIndexPaths]];
}

- (NSArray *)rootNodes;
{
	return [[self arrangedObjects] childNodes];
}

- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
{
	return [[self arrangedObjects] descendantNodeAtIndexPath:indexPath];
}

// all the real objects in the tree, depth-first searching
- (NSArray *)flattenedContent;
{
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (id realNode in self.content) {
		[mutableArray addObject:realNode];
		if (![[realNode valueForKey:[self leafKeyPath]] boolValue])
			[mutableArray addObjectsFromArray:[realNode valueForKey:@"descendants"]];
	}
	return [[mutableArray copy] autorelease];
}

// all the NSTreeNodes in the tree, depth-first searching
- (NSArray *)flattenedNodes;
{
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (NSTreeNode *node in [self rootNodes]) {
		[mutableArray addObject:node];
		if (![[node valueForKey:[self leafKeyPath]] boolValue])
			[mutableArray addObjectsFromArray:[node valueForKey:@"descendants"]];
	}
	return [[mutableArray copy] autorelease];	
}

- (NSTreeNode *)treeNodeForObject:(id)object;
{
	NSTreeNode *treeNode = nil;
	for (NSTreeNode *node in [self flattenedNodes]) {
		if ([node representedObject] == object) {
			treeNode = node;
			break;
		}
	}
	return treeNode;
}

- (void)selectParentFromSelection;
{
	if ([[self selectedNodes] count] == 0)
		return;
	
	NSTreeNode *parentNode = [[[self selectedNodes] firstObject] parentNode];
	if (parentNode)
		[self setSelectionIndexPath:[parentNode indexPath]];
	else
		// no parent exists (we are at the top of tree), so make no selection in our outline
		[self selectNone];
}

- (NSTreeNode *)nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath;
{
	return [[self arrangedObjects] descendantNodeAtIndexPath:[indexPath indexPathByIncrementingLastIndex]];
}

- (NSTreeNode *)nextSiblingOfNode:(NSTreeNode *)node;
{
	return [self nextSiblingOfNodeAtIndexPath:[node indexPath]];
}
@end
