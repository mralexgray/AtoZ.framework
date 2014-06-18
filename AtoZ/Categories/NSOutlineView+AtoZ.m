#import "AtoZ.h"
#import "NSOutlineView+AtoZ.h"

@concreteprotocol(NSOutlineViewDraggable)

- (BOOL) outlineView:(NSOV*)ov          isItemExpandable:(id)x      { return NO; }
-  (int) outlineView:(NSOV*)ov    numberOfChildrenOfItem:(id)x      { return 0;  }
-   (id) outlineView:(NSOV*)ov     child:(int)idx ofItem:(id)x      { return nil; }
-   (id) outlineView:(NSOV*)ov objectValueForTableColumn:(NSTC*)col 
                                                  byItem:(id)x;     { return nil; }
@end

@implementation NSOutlineView (AtoZ)

- (id) selectedObject { return  [[self itemAtRow:self.selectedRow] representedObject]; }

SetKPfVA(SelectedObject,@"selectedRow",@"selectedRowIndexes")

@end

NSString* const kAZTreeNodeChildNodesKey = @"childNodes";

@interface AZTreeNode ()
@property (readwrite,assign,nonatomic) id parentNode;
- (void)insertObject:(id)object inChildNodesAtIndex:(NSUInteger)index;
@end

@implementation AZTreeNode

#pragma mark WCPlistRepresentationProtocol
//- (NSDictionary *)plistRepresentation {
//	
//	[super.plistRepresentation dictionaryByAppendingEntriesFromDictionary:@{[[self childNodes] valueForKeyPath:@"plistRepresentation"],kWCTreeNodeChildNodesKey
//	// addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:, nil]];
//	
//	return [[retval copy] autorelease];
//}
#pragma mark *** Protocol Overrides *** NSKeyValueObserving
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
		return [key isEqualToString:@"isLeaf"] ? [[super keyPathsForValuesAffectingValueForKey:key] setByAddingObject:kAZTreeNodeChildNodesKey]
															: [super keyPathsForValuesAffectingValueForKey:key];
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder*)cdr {
	if (self != [super initWithCoder:cdr]) return nil;
	for (id node in [cdr decodeObjectForKey:kAZTreeNodeChildNodesKey])
		[self insertObject:node inChildNodesAtIndex:_childNodes.count];
	return self;
}

- (void)encodeWithCoder:(NSCoder*)cdr { [super encodeWithCoder:cdr]; [cdr encodeObject:self.childNodes forKey:kAZTreeNodeChildNodesKey];
}
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {

	__typeof__(self) copy = [super performString:@"copyWithZone:" withObject:(__bridge id)zone];
	copy->_parentNode = _parentNode;
	copy->_childNodes = [_childNodes mutableCopy];
	return copy;
}
#pragma mark NSMutableCopying
- (id)mutableCopyWithZone:(NSZone *)zone {

//	typeof(self) copy = [super mutableCopyWithZone:zone];
	__typeof__(self) copy = [super performString:@"mutableCopyWithZone:" withObject:(__bridge id)zone];	copy->_parentNode = _parentNode;
	NSMutableArray *cnodes = [NSMutableArray.alloc initWithCapacity:[_childNodes count]];
	copy->_childNodes = cnodes;
	for (AZTreeNode *node in _childNodes)
		[copy insertObject:node.mutableCopy inChildNodesAtIndex:[cnodes count]];
	return copy;
}
#pragma mark *** Public Methods ***
- (BOOL)isDescendantOfNode:(AZTreeNode*)node; {
	return [node.descendantNodes containsObject:self];
}
#pragma mark NSKeyValueCoding
- (id)objectInChildNodesAtIndex:(NSUInteger)index; {
	return [_childNodes objectAtIndex:index];
}

- (void)addObjectToChildNodes:(id)object; {
	[self insertObject:object inChildNodesAtIndex:[self countOfChildNodes]];
}
- (void)insertObject:(id)object inChildNodesAtIndex:(NSUInteger)index; {
	if (!_childNodes)
		_childNodes = NSMutableArray.new;
	
	[object setParentNode:self];
	
	[_childNodes insertObject:object atIndex:index];
}
- (void)removeObjectFromChildNodesAtIndex:(NSUInteger)index; {
	[[_childNodes objectAtIndex:index] setParentNode:nil];
	
	[_childNodes removeObjectAtIndex:index];
}
#pragma mark Accessors
//@synthesize parentNode=_parentNode;
//@synthesize childNodes=_childNodes;
@dynamic isLeaf,
			mutableChildNodes, 		countOfChildNodes,
			descendantNodes, 			descendantNodesInclusive,
			descendantLeafNodes, 	descendantLeafNodesInclusive,
			descendantGroupNodes,	descendantGroupNodesInclusive;

- (NSMutableArray *)mutableChildNodes {	if (!_childNodes) _childNodes = NSMutableArray.new;
	
	return [self mutableArrayValueForKey:kAZTreeNodeChildNodesKey];
}
- (BOOL) isLeaf {	return ([self countOfChildNodes] == 0)?YES:NO; }
- (NSUI) countOfChildNodes { return [_childNodes count]; }
- (NSA*) descendantNodes; {
	NSMutableArray *retval = [NSMutableArray array];
	
	for (AZTreeNode *node in self.childNodes) { [retval addObject:node];
		[node isLeaf] ?: [retval addObjectsFromArray:[node descendantNodes]];
	}
	return retval.copy;
}
- (NSA*) descendantNodesInclusive; { return [self.descendantNodes arrayByAddingObject:self];	}
- (NSA*)descendantLeafNodes; {

	NSMutableArray *retval = [NSMutableArray array];
	for (AZTreeNode *node in [self childNodes])
		node.isLeaf ? [retval addObject:node] : [retval addObjectsFromArray:[node descendantLeafNodes]];
	return retval.copy;
}
- (NSA*) descendantLeafNodesInclusive { return self.isLeaf ? @[self] : self.descendantLeafNodes; }

- (NSA*)descendantGroupNodes; { NSMutableArray *retval = [NSMutableArray array];
	
	for (AZTreeNode *node in self.childNodes) {
		if (node.isLeaf) return nil;
		[retval addObject:node]; [retval addObjectsFromArray:[node descendantGroupNodes]];
	}
	return retval.copy;
}
- (NSA*)descendantGroupNodesInclusive {
	if (![self isLeaf])
		return [[self descendantGroupNodes] arrayByAddingObject:self];
	return [NSArray array];
}

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
- (NSA*) rootNodes		{	return (NSA*)[self.arrangedObjects childNodes];	}
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
	if ((parentNode = (NSTreeNode*)[self.selectedNodes.first parentNode]))  [self setSelectionIndexPath:parentNode.indexPath];
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

	return [self.childNodes reduce:NSMA.new withBlock:^id(NSMA* sum, id child) {
		[sum addObject:child];	if (![child isLeaf]) [sum addObjectsFromArray:[child descendants]]; return sum;
	}];
}
- (NSA*) groupDescendants	{

	return [self.childNodes reduce:NSMA.new withBlock:^id(id sum, NSTreeNode *item) {
		return item.isLeaf ? sum : [sum arrayByAddingObjectsFromArray:[@[item] arrayByAddingObjectsFromArray:item.groupDescendants]];
	}];
}
- (NSA*) leafDescendants	{
	
	return [[self.childNodes reduce:NSMA.new withBlock:^id(NSMA* sum, NSTreeNode *item){
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

@implementation NSTreeController (NSTreeController_WCExtensions)
// returns an array of all the NSTreeNode objects maintained by the receiver
- (NSArray *)treeNodes; {
	return [(NSA*)[self.arrangedObjects childNodes] reduce:@[] withBlock:^id(id sum, NSTreeNode *node){
		sum = [sum arrayByAddingObject:node];
		return node.isLeaf ? sum : [sum arrayByAddingObjectsFromArray:node.descendants];
	}];
//	return [[nodes copy] autorelease];
}
// returns the selected NSTreeNode object, or if multiple selection is enabled, the first selected NSTreeNode object
- (NSTreeNode *)selectedNode; {
	return [[self selectedNodes] firstObject];
}
// returns the real model object from the above method
- (id)selectedRepresentedObject; {
	return [[self selectedNode] representedObject];
}
// returns the array of selected real model objects
- (NSArray *)selectedRepresentedObjects; {
	return [[self selectedNodes] valueForKey:@"representedObject"];
}
// returns the corresponding NSTreeNode for 'indexPath'
- (NSTreeNode *)treeNodeAtIndexPath:(NSIndexPath *)indexPath; {
	return [[self arrangedObjects] descendantNodeAtIndexPath:indexPath];
}
// returns an array of NSTreeNode objects given an array of NSIndexPath objects 'indexPaths'
- (NSArray *)treeNodesAtIndexPaths:(NSArray *)indexPaths; {
	NSMutableArray *retval = [NSMutableArray array];
	for (NSIndexPath *indexPath in indexPaths) {
		NSTreeNode *node = [self treeNodeAtIndexPath:indexPath];
		if (node)
			[retval addObject:node];
	}
	return retval.copy;
}
// returns the NSIndexPath for the real model object 'representedObject'
- (NSIndexPath *)indexPathForRepresentedObject:(id)representedObject; {
	for (NSTreeNode *node in [self treeNodes]) {
		if ([representedObject isEqual:[node representedObject]])
			return [node indexPath];
	}
	return nil;
}
// returns an array of NSIndexPath objects given an array of real model objects 'representedObjects'
- (NSArray *)indexPathsForRepresentedObjects:(NSArray *)representedObjects; {
	NSMutableArray *indexPaths = [NSMutableArray array];
	NSArray *nodes = [self treeNodes];
	
	for (id representedObject in representedObjects) {
		for (NSTreeNode *node in nodes) {
			if ([representedObject isEqual:[node representedObject]]) {
				[indexPaths addObject:[node indexPath]];
				break;
			}
		}
	}
	return indexPaths.copy;
}
// returns the corresponding NSTreeNode object for the real model object 'representedObject'
- (NSTreeNode *)treeNodeForRepresentedObject:(id)representedObject; {
	for (NSTreeNode *node in [self treeNodes]) {
		if ([representedObject isEqual:[node representedObject]])
			return node;
	}
	return nil;
}
// returns an array of corresponding NSTreeNode objects for the array of real model objects 'representedObjects'
- (NSArray *)treeNodesForRepresentedObjects:(NSArray *)representedObjects; {
	NSMutableArray *treeNodes = [NSMutableArray array];
	NSArray *nodes = [self treeNodes];
	
	for (id representedObject in representedObjects) {
		for (NSTreeNode *node in nodes) {
			if ([representedObject isEqual:[node representedObject]]) {
				[treeNodes addObject:node];
				break;
			}
		}
	}
	return treeNodes.copy;
}
// selects 'treeNode' using its index path
- (void)setSelectedTreeNode:(NSTreeNode *)treeNode; {
	[self setSelectedTreeNodes:[NSArray arrayWithObject:treeNode]];
}
// selects an array of NSTreeNode objects 'treeNodes' using their index paths
- (void)setSelectedTreeNodes:(NSArray *)treeNodes; {
	[self setSelectionIndexPaths:[treeNodes valueForKey:@"indexPath"]];
}
// selects the real model object 'representedObject'
- (void)setSelectedRepresentedObject:(id)representedObject; {
	[self setSelectedRepresentedObjects:[NSArray arrayWithObject:representedObject]];
}
// selects an array of real model objects 'representedObjects'
- (void)setSelectedRepresentedObjects:(NSArray *)representedObjects; {
	NSMutableArray *indexPaths = [NSMutableArray array];
	NSArray *nodes = [self treeNodes];
	
	for (id representedObject in representedObjects) {
		for (NSTreeNode *node in nodes) {
			if ([representedObject isEqual:[node representedObject]]) {
				[indexPaths addObject:[node indexPath]];
				break;
			}
		}
	}
	[self setSelectionIndexPaths:indexPaths];
}
/*
- (void)removeSelectedNodes; {
	[self removeObjectsAtArrangedObjectIndexPaths:[self selectionIndexPaths]];
}

- (void)removeTreeNodes:(NSArray *)treeNodes; {
	[self removeObjectsAtArrangedObjectIndexPaths:[treeNodes valueForKey:@"indexPath"]];
}

- (void)removeRepresentedObject:(id)representedObject; {
	[self removeRepresentedObjects:[NSArray arrayWithObject:representedObject]];
}

- (void)removeRepresentedObjects:(NSArray *)representedObjects; {
	NSMutableArray *indexPaths = [NSMutableArray array];
	NSArray *nodes = [self treeNodes];
	for (id object in representedObjects) {
		for (NSTreeNode *node in nodes) {
			if ([[node representedObject] isEqual:object]) {
				[indexPaths addObject:[node indexPath]];
				break;
			}
		}
	}
	[self removeObjectsAtArrangedObjectIndexPaths:indexPaths];
}
 */
@end


@implementation NSBrowser (AtoZ)

- (NSA*) selectedObjects {

  return [self.selectionIndexPaths mapArray:^id(NSIndexPath * ip) {
		return [self itemAtIndexPath:ip];
	}];
}

@end
