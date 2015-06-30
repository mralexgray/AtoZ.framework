
#define NSTN NSTreeNode

#import "AZObject.h"

#pragma mark - NSOutlineView Hacks for Drag and Drop

#define OVMETHOD(returnTYPE) - (returnTYPE) outlineView:(NSOV*)ov

// fot other stuff dealing with NSTreeController see http://theocacao.com/document.page/130

@protocol NSOutlineViewDraggable
@concrete
- _IsIt_ outlineView:(NSOV*)ov          isItemExpandable: x;
-  (int) outlineView:(NSOV*)ov    numberOfChildrenOfItem: x;
-   (id) outlineView:(NSOV*)ov     child:(int)idx ofItem: x;
-   (id) outlineView:(NSOV*)ov objectValueForTableColumn:(NSTC*)col
                                                  byItem: x;
@end

@interface NSOutlineView (AtoZ)

_RO id selectedObject;
@end

extern NSString* const kAZTreeNodeChildNodesKey;

//@protocol  AZPlistRepresentation;
@interface AZTreeNode : NSObject <NSCoding,NSCopying,NSMutableCopying> { //AZPlistRepresentation
@private
		  __weak id   _parentNode; // back pointer to our parent node; not retained
	NSMutableArray * _childNodes;
}
@property (readonly,nonatomic) id parentNode;
_RO NSA * childNodes;
_RO NSMA * mutableChildNodes; // returns a proxy through mutableArrayValueForKey:
_RO BOOL   isLeaf;
_RO NSUI   countOfChildNodes;
_RO NSA * descendantNodes;
_RO NSA * descendantNodesInclusive;
_RO NSA * descendantLeafNodes,
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
- _IsIt_ isDescendantOfNode:				(NSTN*)node;
- _IsIt_    isSiblingOfNode:				(NSTN*)node;
- _IsIt_ isSiblingOfOrDescendantOfNode:(NSTN*)node;
- (NSIndexPath*) adjacentIndexPath;
- (NSIndexPath*) nextSiblingIndexPath;
- (NSIndexPath*) nextChildIndexPath;
@end

@interface NSTreeController (ESExtensions)
_RO NSA * rootNodes, *flattenedNodes, *flattenedContent;
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
- _Void_ removeSelectedNodes;
- _Void_ removeTreeNodes:(NSArray *)treeNodes;
- _Void_ removeRepresentedObject: representedObject;
- _Void_ removeRepresentedObjects:(NSArray *)representedObjects;
*/
@end


@interface NSBrowser (AtoZ)
_RO NSA * selectedObjects;
@end


