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


@implementation NSTreeController (ESExtensions)
- (NSIndexPath *)indexPathForInsertion;	{
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
- (void) selectNone		{	[self removeSelectionIndexPaths:self.selectionIndexPaths];	/*makes a blank selection in the outline view*/ }
- (NSA*) rootNodes		{	return [self.arrangedObjects childNodes];	}
- (NSTreeNode*) nodeAtIndexPath:(NSIndexPath*)indexPath	{	return [self.arrangedObjects descendantNodeAtIndexPath:indexPath];	}
- (NSA*) flattenedContent	{		// all the real objects in the tree, depth-first searching

	return [NSA arrayWithArrays:[self.content cw_mapArray:^id(id realNode){
		return [realNode boolForKey:self.leafKeyPath] ? @[realNode] : [NSA arrayWithArrays:@[@[realNode],[realNode descendants]]];
	}]];
}
- (NSA*) flattenedNodes		{	// all the NSTreeNodes in the tree, depth-first searching

	return [NSA arrayWithArrays:[self.rootNodes cw_mapArray:^id(NSTreeNode *node){
			return  [node boolForKey:self.leafKeyPath] ? @[node] : [NSA arrayWithArrays:@[@[node],node.descendants]];
	}]];
}
- (NSTreeNode*) treeNodeForObject:(id)object	{ 
	
	return [self.flattenedNodes filterOne:^BOOL(NSTreeNode *node) { 	return node.representedObject == object; }];	
}
- (void) selectParentFromSelection				{
	if (!self.selectedNodes.count) return;
	NSTreeNode *parentNode;
	if ((parentNode = [self.selectedNodes.first parentNode]))  [self setSelectionIndexPath:parentNode.indexPath];
		// no parent exists (we are at the top of tree), so make no selection in our outline
	else [self selectNone];
}
- (NSTreeNode*) nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath	{

	return [self.arrangedObjects descendantNodeAtIndexPath:indexPath.indexPathByIncrementingLastIndex];
}
- (NSTreeNode*) nextSiblingOfNode:				(NSTreeNode*)node				{

	return [self nextSiblingOfNodeAtIndexPath:node.indexPath];
}
@end


@implementation NSTreeNode (ESExtensions)

// returns an array of NSTreeNodes descending from self
- (NSA*) descendants			{

	return [self.childNodes reduce:NSMA.new withBlock:^id(id sum, id child) {
		[sum addObject:child];	if (![child isLeaf]) [sum addObjectsFromArray:[child descendants]]; return sum;
	}];
}
- (NSA*) groupDescendants	{

	return [self.childNodes reduce:NSMA.new withBlock:^id(id sum, NSTreeNode *item) {
		return item.isLeaf ? sum : [sum arrayByAddingObjectsFromArray:[@[item] arrayByAddingObjectsFromArray:item.groupDescendants]];
	}];
}
- (NSA*) leafDescendants	{
	
	return [[self.childNodes reduce:NSMA.new withBlock:^id(id sum, NSTreeNode *item){
		item.isLeaf ? [sum addObject:item]:	[sum addObjectsFromArray:[item leafDescendants]]; return sum;
	}]copy];
}

// all the siblings, including self
- (NSA*) siblings											{	return self.parentNode.childNodes;					}
- (BOOL) isDescendantOfNode:(NSTreeNode*)node	{	return [node.descendants containsObject:self];	}
- (BOOL) isSiblingOfNode:	 (NSTreeNode*)node	{	return self.parentNode == node.parentNode;		}

- (BOOL)	isSiblingOfOrDescendantOfNode:(NSTreeNode *)node {	

	return [self isSiblingOfNode:node] || [self isDescendantOfNode:node];	
}
- (NSIndexPath*) adjacentIndexPath		{  // the next increasing index path

	return self.indexPath.indexPathByIncrementingLastIndex;
}
- (NSIndexPath*) nextSiblingIndexPath	{	// the next 'free' index path at the end of the children array of self's parent
	return [self.parentNode.indexPath indexPathByAddingIndex:self.parentNode.childNodes.count];
}
- (NSIndexPath*) nextChildIndexPath		{	

	return self.isLeaf ? self.nextSiblingIndexPath : [self.indexPath indexPathByAddingIndex:self.childNodes.count];	}
@end
/*
//  NSTreeNode_Extensions.m
//  SortedTree
//  Created by Jonathan Dann on 14/05/2008.
//
//#import "NSTreeNode_Extensions.h"
//#import "NSIndexPath_Extensions.h"

@implementation NSTreeNode (ESExtensions)

// returns an array of NSTreeNodes descending from self
- (NSA*)descendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *child in [self childNodes]) {
		[array addObject:child];
		if (![child isLeaf])
			[array addObjectsFromArray:[child descendants]];
	}
	return [[array copy] autorelease];
}

- (NSA*)groupDescendants;
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

- (NSA*)leafDescendants;
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
- (NSA*)siblings;
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

- (NSA*)rootNodes;
{
	return [[self arrangedObjects] childNodes];
}

- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
{
	return [[self arrangedObjects] descendantNodeAtIndexPath:indexPath];
}

// all the real objects in the tree, depth-first searching
- (NSA*)flattenedContent;
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
- (NSA*)flattenedNodes;
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
*/