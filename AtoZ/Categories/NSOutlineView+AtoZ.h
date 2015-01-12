
#define NSTN NSTreeNode

#import "AtoZUmbrella.h"
#import "AZObject.h"

#pragma mark - NSOutlineView Hacks for Drag and Drop

// fot other stuff dealing with NSTreeController see http://theocacao.com/document.page/130

@protocol NSOutlineViewDraggable
@concrete
- (BOOL) outlineView:(NSOV*)ov          isItemExpandable: x;
-  (int) outlineView:(NSOV*)ov    numberOfChildrenOfItem: x;
-   (id) outlineView:(NSOV*)ov     child:(int)idx ofItem: x;
-   (id) outlineView:(NSOV*)ov objectValueForTableColumn:(NSTC*)col
                                                  byItem: x;
@end

@interface NSOutlineView (AtoZ)

@prop_RO id selectedObject;
@end

extern NSString* const kAZTreeNodeChildNodesKey;

//@protocol  AZPlistRepresentation;
@interface AZTreeNode : NSObject <NSCoding,NSCopying,NSMutableCopying> { //AZPlistRepresentation
@private
		  __weak id   _parentNode; // back pointer to our parent node; not retained
	NSMutableArray * _childNodes;
}
@property (readonly,nonatomic) id parentNode;
@prop_RO  NSA * childNodes;
@prop_RO NSMA * mutableChildNodes; // returns a proxy through mutableArrayValueForKey:
@prop_RO BOOL   isLeaf;
@prop_RO NSUI   countOfChildNodes;
@prop_RO  NSA * descendantNodes;
@prop_RO  NSA * descendantNodesInclusive;
@prop_RO  NSA * descendantLeafNodes,
              * descendantLeafNodesInclusive,
              * descendantGroupNodes,
              * descendantGroupNodesInclusive;

- (BOOL)isDescendantOfNode:(AZTreeNode*)node;
@end

@interface NSTN(ESExtensions)
- (NSA*)        descendants;
- (NSA*)   groupDescendants;
- (NSA*)    leafDescendants;
- (NSA*) 			 siblings;
- (BOOL) isDescendantOfNode:				(NSTN*)node;
- (BOOL)    isSiblingOfNode:				(NSTN*)node;
- (BOOL) isSiblingOfOrDescendantOfNode:(NSTN*)node;
- (NSIndexPath*) adjacentIndexPath;
- (NSIndexPath*) nextSiblingIndexPath;
- (NSIndexPath*) nextChildIndexPath;
@end

@interface NSTreeController (ESExtensions)
@prop_RO NSA * rootNodes, *flattenedNodes, *flattenedContent;
- (void) selectNone;
- (void) selectParentFromSelection;
- (NSIP*) indexPathForInsertion;
- (NSTN*) 		         nodeAtIndexPath:(NSIndexPath*)indexPath;
- (NSTN*)     		 nextSiblingOfNode:(NSTN*)node;
- (NSTN*) nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath;
//+ (instancetype)        instanceWithRootNodes:(NSA*)nodes;
@end

@interface NSTreeController (NSTreeController_WCExtensions)

-  (NSA*) treeNodes;
- (NSTN*) selectedNode;
-    (id) selectedRepresentedObject;
-  (NSA*) selectedRepresentedObjects;

- (NSTN*)   treeNodeAtIndexPath:(NSIP*)ip;
-  (NSA*) treeNodesAtIndexPaths:(NSA*)ips;

- (NSIP*)   indexPathForRepresentedObject:  (id)obj;
-  (NSA*) indexPathsForRepresentedObjects:(NSA*)objs;
- (NSTN*)    treeNodeForRepresentedObject:  (id)obj;
-  (NSA*)  treeNodesForRepresentedObjects:(NSA*)objs;

- (void)			 	 setSelectedTreeNode:(NSTN*)node;
- (void)				setSelectedTreeNodes:(NSA*)nodes;
- (void)  setSelectedRepresentedObject: obj;
- (void) setSelectedRepresentedObjects:(NSA*)objs;
/*
- (void)removeSelectedNodes;
- (void)removeTreeNodes:(NSArray *)treeNodes;
- (void)removeRepresentedObject: representedObject;
- (void)removeRepresentedObjects:(NSArray *)representedObjects;
*/
@end


@interface NSBrowser (AtoZ)
@prop_RO NSA * selectedObjects;
@end


