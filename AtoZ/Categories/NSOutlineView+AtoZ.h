
#define NSTN NSTreeNode

#import "AZObject.h"

@interface NSOutlineView (AtoZ)

@end

extern NSString* const kAZTreeNodeChildNodesKey;

@interface AZTreeNode : AZObject <NSCoding,NSCopying,NSMutableCopying,AZPlistRepresentation> {
@private
		  __weak id   _parentNode; // back pointer to our parent node; not retained
	NSMutableArray * _childNodes;
}
@property (readonly,nonatomic) id parentNode;
@property (readonly,nonatomic) NSA *childNodes;
@property (readonly,nonatomic) NSMA *mutableChildNodes; // returns a proxy through mutableArrayValueForKey:
@property (readonly,nonatomic) BOOL isLeaf;
@property (readonly,nonatomic) NSUI countOfChildNodes;
@property (readonly,nonatomic) NSA *descendantNodes;
@property (readonly,nonatomic) NSA *descendantNodesInclusive;
@property (readonly,nonatomic) NSA *descendantLeafNodes;
@property (readonly,nonatomic) NSA *descendantLeafNodesInclusive;
@property (readonly,nonatomic) NSA *descendantGroupNodes;
@property (readonly,nonatomic) NSA *descendantGroupNodesInclusive;

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
- (NSA*) 			 			  rootNodes;
- (void) 						 selectNone;
- (NSA*)						flattenedNodes;
- (NSA*)              flattenedContent;
- (void)     selectParentFromSelection;
- (NSIndexPath*) indexPathForInsertion;
-  (NSTN*) 		         nodeAtIndexPath:(NSIndexPath*)indexPath;
-  (NSTN*)     		 nextSiblingOfNode:(NSTN*)node;
-  (NSTN*) nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)        instanceWithRootNodes:(NSA*)nodes;
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
- (void)  setSelectedRepresentedObject:(id)obj;
- (void) setSelectedRepresentedObjects:(NSA*)objs;
/*
- (void)removeSelectedNodes;
- (void)removeTreeNodes:(NSArray *)treeNodes;
- (void)removeRepresentedObject:(id)representedObject;
- (void)removeRepresentedObjects:(NSArray *)representedObjects;
*/
@end
