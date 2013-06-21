
#define CEL NSCell

JREnumDeclare( AZOutlineCellStyle, 	AZOutlineCellStyleToggleHeader,
												AZOutlineCellStyleScrollList,
												AZOutlineCellStyleScrollListItem );

AZStruct(AZNodeProtocolKeyPaths,	__unsafe_unretained NSS *keyPath;
											__unsafe_unretained NSS *valuePath;
											__unsafe_unretained NSS *childrenPath; );
//} AZNodeProtocolKeyPaths;

NS_INLINE AZNodeProtocolKeyPaths AZNodeProtocolKeyPathsMake(NSS*kP,NSS*vP,NSS*cP){
	AZNodeProtocolKeyPaths z; z.keyPath = kP; z.valuePath = vP; z.childrenPath = cP; return z;
}

#define AZNODEPRO (NSObject<AtoZNodeProtocol>*)
@protocol AtoZNodeProtocol	<NSObject>
@required
- (AZNodeProtocolKeyPaths) keyPaths;
- (void) addChild:(id<AtoZNodeProtocol>)c;
@optional
//@property (readonly) NSString *valuePath, *keyPath, *childrenPath;
@concrete
@property (nonatomic) NSCellStateValue nodeState;
@property (readwrite, nonatomic) id value, key;
//- (void) setValue:(id)value;
//-   (id) key;
//- (void) setKey:(id)key;
@property (readonly) NSA* children, *allSiblings, *allDescendants; //* allAncestors,
@property (readonly) BOOL isLeaf, isaNode;
@property (readonly) NSUI numberOfChildren, siblingIndexMax, siblingIndex;
@property (weak,readonly) NSObject<AtoZNodeProtocol>* parent;
@end

@interface	AZNode : NSObject	<AtoZNodeProtocol> //NSCopying, NSCoding
@end


JREnumDeclare(AZMethod,
	AZMethodNotFound, 	// method not found (LRMethodNotFound )
	AZMethodAuthor,    	// first in tree to implement method (LRMethodImplement)
	AZMethodOverrider,   // class overrides method (LRMethodOverride)
 	AZMethodInherits     // class does not override superclass method (LRMethodSuper)
);


@interface NSObject (ProtocolConformance)
+ (AZMethod) implementationOfSelector:(SEL)selector;
- (BOOL) implementsProtocol:(id)nameOrProtocol;
+ (BOOL) implementsProtocol:(id)nameOrProtocol;
@end
@interface  NSObject (AtoZNodeProtocol)
@end

//@property (nonatomic,strong)      id   key,
//													value, 
//									        	 	expanded; 
//@property (nonatomic, strong) NSMutableArray * children;
//@property (readonly)         NSArray * allDescendants,
//									          * allAncestors, 
//									          * allSiblings;
//@property (readonly)            BOOL   isLeaf;
//@property (readonly)        NSNumber * of, 
//											    * index, 
//											    * numberOfChildren;
//@property (weak) 	  		      AZNode * parent;

//- (void) addChild:    (AZNode*)o; 
//- (void) removeChild: (AZNode*)o;
//- (void) insertChild: (AZNode*)o atIndex:(NSUInteger)i;
//-   (id) childAtIndex:(NSUInteger)index;
//- (void) sortChildrenUsingFunction:(NSComparisonResult (*)(id, id, void *))compare context:(void *)context;


//@protocol AtoZBundleProtocol <NSObject>
//@optional
//@property (readonly) NSWindowController *azBundle_windowController;
//@property (readonly) NSString	*azBundle_bundleTitle, 
//										*azBundle_bundleDescription;	// may not the same as the actual bundle title @end
//@property (readonly) NSImage 	*azBundle_bundleIcon;
//@property (readonly) BOOL azBundle_isOpen, azBundle_select, azBundle_open;
//- (void) azBundle_close;
//@end

@interface NSObject (AtoZBundleProtocol)
@property (readonly) NSString	*azBundle_bundleTitle, *azBundle_bundleDescription;	// may not the same as the actual bundle title on disk
@property (readonly) NSImage 											*azBundle_bundleIcon;	// may not the same as [NSObject description]
@property (readonly) BOOL  		azBundle_isOpen, azBundle_select, azBundle_open;	// returns YES if its window is currently open
- (void) azBundle_close;																				// closes its window
@end


//azBundle_hasOpenWindows
//@optional
//@property (readonly) NSDictionary *classes;
//@property (readonly) NSDictionary *symbols;
//-(void)close;	// closes its window

//@interface AZBundle : NSObject <AtoZNodeProtocol>
/* properties for the bundle information.  
	note:		information like this is also available in: [NSBundle infoDictionary], which gives you key information from the bundle's Info.plist. However, these accessors are merely convenience accessors for the same information but conveniently provides you, for example, the actual icon image, plus extended localized string information (display name and description)
	note: 	these are provided due to the fact that this information may be different than what's on disk, they are localized strings used for display purposes in the UI
	NOTE: may not the same as the actual bundle title on disk /  may not the same as [NSObject description]
*/

//@property (readonly) NSString	*bundleTitle, *bundleDescription;
//@property (readonly) NSImage	*bundleIcon;
//@end
